//
//  XCTestExtensions.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

extension XCTestCase {
  
  /**
    Wait for expecation to fullfill
   
    - Parameters:
      - description: Expecation description
      - timeout: Expectations timeout
      - testingClosure: Testing closure
  */
  func wait(description: String = #function, timeout: TimeInterval = 1.0,
            testingClosure: (_ expectation: XCTestExpectation) -> Void) {
    let expect = expectation(description: description)
    testingClosure(expect)
    waitForExpectations(timeout: timeout, handler: nil)
  }
}
