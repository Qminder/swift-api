//
//  TicketModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class TicketModelTests: ModelTests {
  
  private let ticketId = String(Int.random)
  private let firstName = String.random
  private let lastName = String.random
  private let lineId = Int.random
  private let createdDate = Date.random
  private let email = "\(String.random)@\(String.random).com"
  
  private var ticketData: [String: Any]!
  
  private func decodeToTicket() -> Ticket? {
    return try? ticketData.decodeAs(Ticket.self, decoder: JSONDecoder.withMilliseconds)
  }
  
  override func setUp() {
    super.setUp()
    
    ticketData = [
      "status": "NEW",
      "source": "MANUAL",
      "firstName": firstName,
      "created": ["date": createdDate.format(.withMilliseconds)],
      "id": ticketId,
      "line": lineId,
      "lastName": lastName,
      "email": email
    ]
  }
  
  func testTicketWithoutMilliseconds() {
    let createdDateWithoutMilliseconds = Date.random
    ticketData["created"] = ["date": createdDate.format(.withoutMilliseconds)]
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.id, ticketId)
    XCTAssertEqual(ticket?.source, .manual)
    XCTAssertEqual(ticket?.status, .new)
    XCTAssertEqual(ticket?.firstName, firstName)
    XCTAssertEqual(ticket?.lastName, lastName)
    XCTAssertEqual(ticket?.email, email)
    XCTAssertEqual(ticket?.line, lineId)
    XCTAssertEqual(ticket?.createdDate, createdDateWithoutMilliseconds)
  }
  
  func testTicketWithMilliseconds() {
    let createdDateStringWithMilliseconds = Date.random
    ticketData["created"] = ["date": createdDateStringWithMilliseconds.format(.withMilliseconds)]
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.createdDate, createdDateStringWithMilliseconds)
  }
  
  func testOrderAfterWithoutMilliseconds() {
    let createdDate = Date.random
    let orderAfterDate = createdDate.addingTimeInterval(1.0)
    
    ticketData["created"] = ["date": createdDate.format()]
    ticketData["orderAfter"] = orderAfterDate.format()
    
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.orderAfter)
    XCTAssertEqual(ticket?.orderAfter, orderAfterDate)
    XCTAssertNotEqual(ticket?.orderAfter, ticket?.createdDate)
  }
  
  func testOrderAfterWithMilliseconds() {
    let createdDate = Date.random
    let orderAfterDate = createdDate.addingTimeInterval(1.0)
    
    ticketData["created"] = ["date": createdDate.format(.withMilliseconds)]
    ticketData["orderAfter"] = orderAfterDate.format(.withMilliseconds)
    
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.orderAfter)
    XCTAssertEqual(ticket?.orderAfter, orderAfterDate)
    XCTAssertNotEqual(ticket?.orderAfter, ticket?.createdDate)
  }
  
  func testCalledDataUserDesk() {
    let calledDate = Date.random
    let lineId = Int.random
    let deskId = Int.random
    let userId = Int.random
    
    ticketData["interactions"] = [
      ["start": calledDate.format(),
       "line": lineId,
       "desk": deskId,
       "user": userId
      ]
    ]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.calledDate)
    XCTAssertEqual(ticket?.calledDate, calledDate)
    XCTAssertEqual(ticket?.userCalledID, userId)
    XCTAssertEqual(ticket?.calledDeskID, deskId)
  }
  
  func testServedDate() {
    let servedDate = Date.random
    ticketData["served"] = ["date": servedDate.format()]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.servedDate)
    XCTAssertEqual(ticket?.servedDate, servedDate)
  }
  
  func testLabels() {
    let labelValue = String.random
    let labelColor = String.random
    
    ticketData["labels"] = [
      [
        "color": labelColor,
        "value": labelValue
      ]
    ]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.labels)
    
    guard let labels = ticket?.labels else {
      XCTFail("Can't get ticket labels")
      return
    }
    
    XCTAssertTrue(labels.contains(where: {
      $0.color == labelColor && $0.value == labelValue
    }))
  }
  
  func testExtraFields() {
    let title = String.random
    let value = String.random
    let url = "http://www.\(String.random).com"
    
    ticketData["extra"] = [
      [
        "title": title,
        "value": value,
        "url": url
      ]
    ]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.extra)
    
    guard let extra = ticket?.extra else {
      XCTFail("Can't get ticket extra data")
      return
    }
    
    XCTAssertTrue(extra.contains(where: {
      $0.title == title && $0.value == value && $0.url == url
    }))
  }
  
  func testInteractions() {
    let startDate = Date.random
    let endDate = startDate.addingTimeInterval(10.0)
    let lineId = Int.random
    let deskId = Int.random
    let userId = Int.random
    
    ticketData["interactions"] = [
      ["start": startDate.format(),
       "end": endDate.format(),
       "line": lineId,
       "desk": deskId,
       "user": userId
      ]
    ]
    let ticket = decodeToTicket()
    
    XCTAssertNotNil(ticket?.interactions)
    
    guard let interaction = ticket?.interactions?.first else {
      XCTFail("Can't get ticket interactions")
      return
    }
    
    XCTAssertEqual(interaction.start, startDate)
    XCTAssertEqual(interaction.end, endDate)
    XCTAssertEqual(interaction.line, lineId)
    XCTAssertEqual(interaction.desk, deskId)
    XCTAssertEqual(interaction.user, userId)
  }
  
  func testSourceName() {
    ticketData["source"] = "NAME"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .name)
  }
  
  func testSourceManual() {
    ticketData["source"] = "MANUAL"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .manual)
  }
  
  func testSourcePrinter() {
    ticketData["source"] = "PRINTER"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .printer)
  }
  
  func testSourceOther() {
    ticketData["source"] = "OTHER"
    let ticket = decodeToTicket()
    
    XCTAssertEqual(ticket?.source, .other)
  }
}
