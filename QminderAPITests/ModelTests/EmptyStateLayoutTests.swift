//
//  EmptyStateLayoutTests.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 15/03/2019.
//  Copyright © 2019 Kristaps Grinbergs. All rights reserved.
//

import XCTest

@testable import QminderAPI

class EmptyStateLayoutTests: XCTestCase {
  
  private func testEmptyState(_ text: String, with layout: EmptyStateLayout) {
    let emptyState = EmptyStateLayout(rawValue: text)
    XCTAssertEqual(emptyState, layout)
  }
  
  func testConnected() {
    testEmptyState("connected", with: .connected)
  }
  
  func testGoodMorning() {
    testEmptyState("goodMorning", with: .goodMorning)
  }
  
  func testClosed() {
    testEmptyState("closed", with: .closed)
  }
  
  func testSignIniPad() {
    testEmptyState("signIniPad", with: .signIniPad)
  }
  
  func testOnBreak() {
    testEmptyState("onbreak", with: .onBreak)
  }
  
  func testSignIn() {
    testEmptyState("signIn", with: .signIn)
  }
}
