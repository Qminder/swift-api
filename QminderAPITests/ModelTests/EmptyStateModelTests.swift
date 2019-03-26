//
//  EmptyStateModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class EmptyStateModelTests: ModelTests {
  
  private var message: String!
  
  override func setUp() {
    super.setUp()
    message = String.random
  }
  
  func testParsingEmptyStateSimple() {
    
    let data: [String: Any] = [
      "layout": "other",
      "message": message
    ]
    let emptyState = try? data.decodeAs(EmptyState.self)
    
    XCTAssertEqual(emptyState?.message, message)
    XCTAssertEqual(emptyState?.layout, .other)
  }
  
  func testParsingEmptyStateClosed() {
    let data: [String: Any] = [
      "layout": "closed",
      "message": message
    ]
    let emptyState = try? data.decodeAs(EmptyState.self)
    
    XCTAssertEqual(emptyState?.message, message)
    XCTAssertEqual(emptyState?.layout, .closed)
  }
  
  func testOtherEmptyState() {
    let data: [String: Any] = [
      "layout": "other",
      "message": message
    ]
    let emptyState = try? data.decodeAs(EmptyState.self)
    
    XCTAssertEqual(emptyState?.message, message)
    XCTAssertEqual(emptyState?.layout, .other)
  }
}
