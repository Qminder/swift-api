//
//  TicketsAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class TicketsAPITests: QminderAPITests {
  func ticketDetails(ticketID: String) {
    var ticket: Ticket?
    
    wait { expectation in
      qminderAPI.getTicketDetails(ticketId: ticketID) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          ticket = value
          
          expectation.fulfill()
        case let .failure(error):
          XCTFail("Can't get ticket details \(error)")
        }
      }
    }
    
    XCTAssertNotNil(ticket)
    XCTAssertNotNil(ticket?.id)
    XCTAssertNotNil(ticket?.source)
    XCTAssertNotNil(ticket?.status)
    XCTAssertNotNil(ticket?.line)
    XCTAssertNotNil(ticket?.created)
  }
}
