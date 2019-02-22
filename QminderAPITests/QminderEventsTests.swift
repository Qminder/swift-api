//
//  QminderEventsTests.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 10/05/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import XCTest

@testable import QminderAPI

class QminderEventsMock: QminderEventsProtocol {
  
  weak var delegate: QminderEventsDelegate?
  
  func openSocket() {
    delegate?.onConnected()
  }
  
  func reOpenSocket() {
    delegate?.onConnected()
  }
  
  func closeSocket() {
    let error = NSError(domain: "FakeError", code: 1, userInfo: [:])
    delegate?.onDisconnected(error: error)
  }
  
  func subscribe(toTicketEvent eventType: TicketWebsocketEvent,
                 parameters: [String: Any],
                 callback: @escaping (Result<Ticket, QminderError>) -> Void) {
    let ticket = Ticket(statusCode: 200,
                        id: "1",
                        number: nil,
                        line: 1,
                        source: .name,
                        status: .new,
                        firstName: "Name",
                        lastName: "Surname",
                        phoneNumber: 123456789,
                        email: "test@example.com",
                        created: Created.init(date: Date()),
                        served: nil,
                        labels: [Label(color: "black", value: "blackLabel")],
                        extra: [Extra(title: "Title", value: "value", url: "https:///www.google.com")],
                        orderAfter: nil,
                        interactions: nil)
    callback(Result(ticket))
  }
  
  func subscribe(toDeviceEvent eventType: DeviceWebsocketEvent,
                 parameters: [String: Any],
                 callback: @escaping (Result<TVDevice?, QminderError>) -> Void) {
    
    let settings = Settings.init(selectedLine: 1,
                                 lines: [1, 2, 3],
                                 clearTickets: .afterCalling,
                                 notificationViewLineVisible: false)
    let tvDevice = TVDevice(statusCode: 200,
                            id: 1,
                            name: "Device",
                            theme: "standard",
                            layout: "standard",
                            settings: settings)
    
    callback(Result(tvDevice))
  }
  
  func subscribe(toLineEvent eventType: LineWebsocketEvent,
                 parameters: [String: Any],
                 callback: @escaping (Result<[Line], QminderError>) -> Void) {
    
    let lines = [Line(statusCode: 200, id: 1, name: "Line1", location: 1),
                 Line(statusCode: 200, id: 2, name: "Line2", location: 1),
                 Line(statusCode: 200, id: 3, name: "Line3", location: 1)]
    callback(Result(lines))
  }
}

class QminderEventsTests: XCTestCase {
  
  private var qminderEvents: QminderEventsProtocol?
  
  private var isConnected = false
  private var error: Error?
  
  override func setUp() {
    qminderEvents = QminderEventsMock()
    qminderEvents?.delegate = self
    qminderEvents?.openSocket()
  }
  
  func testConnected() {
    XCTAssertTrue(isConnected)
  }
  
  func testClosed() {
    qminderEvents?.closeSocket()
    
    XCTAssertFalse(isConnected)
    
    let nsError = self.error as NSError?
    XCTAssertNotNil(nsError)
    XCTAssertEqual(nsError?.domain, "FakeError")
    XCTAssertEqual(nsError?.code, 1)
  }
  
  func testOverviewMonitorChange() {
    let overviewMonitorChangeExpectation = self.expectation(description: "overviewMonitorChange")
    qminderEvents?.subscribe(toDeviceEvent: .overviewMonitorChange, parameters: ["id": "1"]) { result in
      
      XCTAssertNil(result.error)
      
      switch result {
      case .failure(let error):
        print("fail \(error)")
        
      case let .success(device):
        XCTAssertNotNil(device)
        XCTAssertEqual(device?.id, 1)
        XCTAssertEqual(device?.name, "Device")
        XCTAssertEqual(device?.layout, "standard")
        XCTAssertEqual(device?.theme, "standard")
        
        let settings = device?.settings
        XCTAssertEqual(settings?.selectedLine, 1)
        XCTAssertEqual(settings?.lines, [1, 2, 3])
        XCTAssertEqual(settings?.clearTickets, .afterCalling)
        
        overviewMonitorChangeExpectation.fulfill()
      }
    }
    self.waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testLineEvent() {
    let lineEventExpectation = self.expectation(description: "lineEvent")
    qminderEvents?.subscribe(toLineEvent: .changed, parameters: ["id": 1]) { result in
      switch result {
      case .failure(let error):
        print("fail \(error)")
        
      case let .success(lines):
        XCTAssertEqual(lines.count, 3)
        
        let firstLine = lines.first
        XCTAssertEqual(firstLine?.id, 1)
        XCTAssertEqual(firstLine?.name, "Line1")
        XCTAssertEqual(firstLine?.location, 1)
        
        let lastLine = lines.last
        XCTAssertEqual(lastLine?.id, 3)
        XCTAssertEqual(lastLine?.name, "Line3")
        XCTAssertEqual(lastLine?.location, 1)
        
        lineEventExpectation.fulfill()
      }
    }
    self.waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testTicketEvent() {
    let ticketCreatedExpectation = self.expectation(description: "ticketCreated")
    qminderEvents?.subscribe(toTicketEvent: .created, parameters: ["location": 1]) { result in
      switch result {
      case .failure(let error):
        print("fail \(error)")
      case let .success(ticket):
        XCTAssertEqual(ticket.id, "1")
        XCTAssertEqual(ticket.firstName, "Name")
        XCTAssertEqual(ticket.lastName, "Surname")
        XCTAssertEqual(ticket.source, .name)
        XCTAssertEqual(ticket.status, .new)
        XCTAssertEqual(ticket.phoneNumber, 123456789)
        XCTAssertNotNil(ticket.created.date)
        
        XCTAssertNotNil(ticket.labels)
        XCTAssertEqual(ticket.labels?.count, 1)
        let firstLabel = ticket.labels?.first
        XCTAssertEqual(firstLabel?.color, "black")
        XCTAssertEqual(firstLabel?.value, "blackLabel")
        
        XCTAssertNotNil(ticket.extra)
        XCTAssertEqual(ticket.extra?.count, 1)
        let firstExtra = ticket.extra?.first
        XCTAssertEqual(firstExtra?.title, "Title")
        XCTAssertEqual(firstExtra?.value, "value")
        XCTAssertEqual(firstExtra?.url, "https:///www.google.com")
        ticketCreatedExpectation.fulfill()
      }
    }
    self.waitForExpectations(timeout: 1.0, handler: nil)
  }
}

extension QminderEventsTests: QminderEventsDelegate {
  func onConnected() {
    isConnected = true
  }
  
  func onDisconnected(error: Error?) {
    print(error ?? "")
    self.error = error
    isConnected = false
  }
}
