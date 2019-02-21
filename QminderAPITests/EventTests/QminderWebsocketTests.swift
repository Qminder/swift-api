//
//  QminderWebsocketTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 29/01/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class QminderWebsocketTests: XCTestCase {
  /// Qminder API client
  var qminderAPI: QminderAPI!
  var events: QminderEvents!
  
  /// Location ID
  let locationId: Int = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
  
  var parameters: [String: Any] = [:]
  var eventsResponses: [Ticket] = []
  var deviceResponse = false
  var linesResponses: [[Line]] = []
  
  override func setUp() {
    super.setUp()
    
    if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
      qminderAPI = QminderAPI(apiKey: apiKey)
      events = QminderEvents(serverAddress: "ws://127.0.0.1:8889")
    }
    
    parameters = ["location": locationId]
    
    subscribeToTicket(.created, parameters: parameters)
    subscribeToTicket(.called, parameters: parameters)
    subscribeToTicket(.recalled, parameters: parameters)
    subscribeToTicket(.cancelled, parameters: parameters)
    subscribeToTicket(.served, parameters: parameters)
    subscribeToTicket(.changed, parameters: parameters)
    
    subscribeToTVChanged()
    subscribeLines(parameters: parameters)
  }
  
  override func tearDown() {
    super.tearDown()
    
    events.closeSocket()
  }
  
  func testWebsocketEvents() {
    // Test run #1
    // Ticket created
    addTestTimer { ticket in
      ticket.status == .new && ticket.id == "23853943"
        && ticket.firstName == "Name" && ticket.lastName == "Surname"
        && ticket.email == "test@example.com"
    }
    
    // Ticket edited
    addTestTimer { ticket in
      ticket.id == "23853943"
        && ticket.firstName == "Name2" && ticket.lastName == "Surname2"
    }
    
    // Ticket deleted
    addTestTimer { ticket in
      ticket.status == .cancelledByClerk &&
        ticket.id == "23853943" &&
        ticket.firstName == "Name2" &&
        ticket.lastName == "Surname2"
    }
    
    // Test run #2
    // Ticket created
    addTestTimer { ticket in
      ticket.status == .new && ticket.id == "23856820"
        && ticket.firstName == "Name1" && ticket.lastName == "Surname1"
        && ticket.email == "test1@example.com"
    }
    
    // Ticket edited
    addTestTimer { ticket in
      ticket.status == .new && ticket.id == "23856820" && ticket.firstName == "Name" && ticket.lastName == "Surname"
    }
    
    ticketCalled()
    ticketRecalled()
    ticketServed()
    
    overviewMonitorDidChange()
    linesChanged()
    
    waitForExpectations(timeout: 40, handler: nil)
  }
  
  fileprivate func ticketCalled() {
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:11Z") else {
        return false
      }
      
      guard let calledDate = ticket.calledDate else {
        return false
      }
      
      return ticket.id == "23856820" &&
        ticket.status == .called &&
        ticket.firstName == "Name" &&
        ticket.lastName == "Surname" &&
        date.compare(calledDate) == ComparisonResult.orderedSame
    }
  }
  
  fileprivate func ticketRecalled() {
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:21Z") else {
        return false
      }
      
      guard let calledDate = ticket.calledDate else {
        return false
      }
      
      return ticket.id == "23856820" &&
        ticket.status == .called &&
        ticket.firstName == "Name" &&
        ticket.lastName == "Surname" &&
        date.compare(calledDate) == ComparisonResult.orderedSame
    }
  }
  
  fileprivate func ticketServed() {
    addTestTimer { ticket in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let date = formatter.date(from: "2017-02-06T13:36:36Z") else {
        return false
      }
      
      guard let servedDate = ticket.served?.date else {
        return false
      }
      
      return ticket.id == "23856820" &&
        ticket.status == .served &&
        ticket.firstName == "Name" &&
        ticket.lastName == "Surname" &&
        date.compare(servedDate) == ComparisonResult.orderedSame
    }
  }
  
  func overviewMonitorDidChange() {
    let overviewMonitorExpectation = expectation(description: "testOverviewMonitorDidChange")

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      if self.deviceResponse {
        overviewMonitorExpectation.fulfill()
        timer.invalidate()
      }
    }
  }

  func linesChanged() {
    let linesChangedExpectation = expectation(description: "testLinesChanged")

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      if let lines = self.linesResponses.first,
        lines.contains(where: { $0.id == 1 && $0.name == "Business" }),
        lines.contains(where: { $0.id == 2 && $0.name == "Private" }),
        lines.contains(where: { $0.id == 3 && $0.name == "Information" }) {
        linesChangedExpectation.fulfill()
        timer.invalidate()
      }
    }
  }
  
  fileprivate func subscribeToTicket(_ ticketEvent: TicketWebsocketEvent, parameters: [String: Any]) {
    events.subscribe(toTicketEvent: ticketEvent, parameters: parameters, callback: {[weak self] result in
      
      XCTAssertTrue(Thread.isMainThread)
      
      switch result {
      case let .success(ticket):
        print(ticket)
        
        self?.eventsResponses.append(ticket)
      default:
        break
      }
    })
  }
  
  fileprivate func subscribeToTVChanged() {
    events.subscribe(toDeviceEvent: .overviewMonitorChange, parameters: ["id": 333]) { result in
      
      XCTAssertTrue(Thread.isMainThread)
      
      switch result {
      case .success:
        self.deviceResponse = true
        
      default:
        break
      }
    }
  }
  
  fileprivate func subscribeLines(parameters: [String: Any]) {
    events.subscribe(toLineEvent: .changed, parameters: parameters) {[weak self] result in
      
      XCTAssertTrue(Thread.isMainThread)
      
      switch result {
      case let .success(line):
        print(line)
        self?.linesResponses.append(line)
        
      default:
        break
      }
    }
  }
  
  /**
   Add test timer as expectation
   
   - Parameters:
     - description: Expecation description
     - pollInterval: Poll interval
     - checker: Checker block
  */
  func addTestTimer(description: String = #function + String(#line),
                    pollInterval: TimeInterval = 1.0, checker: @escaping (Ticket) -> Bool) {
    
    let expect = expectation(description: description)
    
    Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { timer in
      if self.eventsResponses.contains(where: { checker($0) }) {
        expect.fulfill()
        timer.invalidate()
      }
    }
  }
}
