//
//  ViewController.swift
//  QminderTVApp
//
//  Created by Kristaps Grinbergs on 27/10/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//

import UIKit
import QminderAPI

struct EventInfo {
  var type: TicketWebsocketEvent
  var ticket: Ticket
}

/// Demonstrates Qminder iOS API usage in Apple TV
class ViewController: UIViewController, QminderEventsDelegate, UITableViewDelegate, UITableViewDataSource {
  
  /// Events array
  private var eventsArray:[EventInfo] = []
  
  /// Timer to check pair status
  private var timer = Timer()
  
  /// Qminder API provider
  private var qminderAPI: QminderAPI!
  
  /// Qminder Websockets provider
  private var events: QminderEvents!
  
  /// JSON decoder with milliseconds
  private let jsonDecoderWithMilliseconds: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    
    let dateISO8601Formatter = DateFormatter()
    dateISO8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let dateISO8601MillisecondsFormatter = DateFormatter()
    dateISO8601MillisecondsFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    jsonDecoder.dateDecodingStrategy = .custom({decoder -> Date in
      
      let container = try decoder.singleValueContainer()
      let dateStr = try container.decode(String.self)
      
      // possible date strings: "yyyy-MM-dd'T'HH:mm:ssZ" or "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      var tmpDate: Date? = nil
      
      if dateStr.count == 24 {
        tmpDate = dateISO8601MillisecondsFormatter.date(from: dateStr)
      } else {
        tmpDate = dateISO8601Formatter.date(from: dateStr)
      }
      
      guard let date = tmpDate else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
      }
      
      return date
    })
    
    return jsonDecoder
  }()
  
  /// Pairing code label
  @IBOutlet var pairingCode: UILabel!
  
  /// Events table view
  @IBOutlet var tableView:UITableView?
  
  /// Offline label
  @IBOutlet var offlineLabel: UILabel!
  
  /// Online label
  @IBOutlet var onlineLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let key = UserDefaults.standard.string(forKey: "API_KEY")
  
    if key != nil && UserDefaults.standard.object(forKey: "LOCATION_ID") != nil {
    
      print("API key loaded from UserDefaults")
      
      qminderAPI = QminderAPI(apiKey: key!)

      qminderAPI.getLocationsList(completion: {result in
        switch result {
          case .failure(let error):
            print("Can't get location list \(error)")
          
          case .success(let locations):
            print(locations)
        }
      })
    
      events = QminderEvents(apiKey: key!)
      events.delegate = self
      events.openSocket()
      
      let locationId = UserDefaults.standard.integer(forKey: "LOCATION_ID")
      
      setEvents(locationId: locationId)
      
    } else {
      qminderAPI = QminderAPI()
      qminderAPI.getPairingCodeAndSecret(completion: {result in
      
        switch result {
          case .failure(let error):
            print("Can't get pairing code and secret \(error)")
          
          case .success(let pairingData):
            self.pairingCode.text = pairingData.code
    
            self.timer.invalidate()
        
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
              (timer) in

                self.qminderAPI.pairTV(code: pairingData.code, secret: pairingData.secret, completion: {result in

                  switch result {
                    case .failure(let error):
                      print("Can't pair TV \(error)")
                    
                    case .success(let tvData):
                  
                      if tvData.status == .paired {
                        timer.invalidate()
                      
                        UserDefaults.standard.set(tvData.apiKey, forKey: "API_KEY")
                        UserDefaults.standard.set(tvData.id, forKey: "TV_ID")
                        UserDefaults.standard.set(tvData.location, forKey: "LOCATION_ID")
                      
                        if let key = tvData.apiKey {
                          self.events = QminderEvents(apiKey: key)
                          self.events.delegate = self
                          self.events.openSocket()
                          
                          self.setEvents(locationId: tvData.location!)
                        }
                      }
                  }
                })
              
            })
        }
      })
    }
  }
  
  func setEvents(locationId:Int) {
    
    let parameters = ["location": locationId]

    events.subscribe(toTicketEvent: .created, parameters: parameters, callback: { result in
      self.messageReceived(eventType: .created, result: result)
    })
    
    events.subscribe(toTicketEvent: .cancelled, parameters: parameters, callback: { result in
      self.messageReceived(eventType: .cancelled, result: result)
    })
    
    events.subscribe(toTicketEvent: .changed, parameters: parameters, callback: { result in
      self.messageReceived(eventType: .changed, result: result)
    })
    
    events.subscribe(toTicketEvent: .called, parameters: parameters, callback: { result in
      self.messageReceived(eventType: .called, result: result)
    })
    
    events.subscribe(toTicketEvent: .recalled, parameters: parameters, callback: { result in
      self.messageReceived(eventType: .recalled, result: result)
    })
    
    events.subscribe(toTicketEvent: .served, parameters: parameters, callback: { result in
      self.messageReceived(eventType: .served, result: result)
    })
    
    events.subscribe(toDeviceEvent: .overviewMonitorChange, parameters: ["parameters": ["id": UserDefaults.standard.integer(forKey: "TV_ID")]], callback: { result in
      print("TV changed")
    })
    
    events.subscribe(toLineEvent: .changed, parameters: ["parameters": ["id": UserDefaults.standard.integer(forKey: "LOCATION_ID")]], callback: { result in
      print("Lines changed")
    })
  }
  
  @available(tvOS 2.0, *)
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let eventInfo:EventInfo = eventsArray[indexPath.row]
    
    var cell = tableView.dequeueReusableCell(withIdentifier: eventInfo.type.rawValue)
    
    if cell == nil {
      cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
    }
    
    cell?.textLabel?.text = "\(eventInfo.type.rawValue) : \(eventInfo.ticket.status.rawValue)"
    
    return cell!
  }

  
  @available(tvOS 2.0, *)
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.eventsArray.count
  }
  

  public func onTicketCreated(ticket: Ticket) {
    print(ticket)
  }
  
  public func onDisconnected(error: Error?) {
    print("disconnected")
    
    onlineLabel.isHidden = true
    offlineLabel.isHidden = false
  }

  public func onConnected() {
    print("connected")
    
    onlineLabel.isHidden = false
    offlineLabel.isHidden = true
    
    tableView?.isHidden = false
    pairingCode.isHidden = true
  }
  
  func messageReceived(eventType: TicketWebsocketEvent, result: QminderResult<Ticket, QminderError>) {
    switch result {
      case .success(let ticket):
        print("\(eventType.rawValue) \(ticket)")
      
        self.eventsArray.insert(EventInfo(type: eventType, ticket: ticket), at: 0)
        self.tableView?.reloadData()
      
      case .failure(let error):
        print("\(error)")
    }
  }

}
