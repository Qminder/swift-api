//
//  QminderResultTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class QminderResultTests: XCTestCase {
  
  func testResultSucess() {
    
    let value = UUID().uuidString
    let result = Result<String, QminderError>(value)
    
    XCTAssertFalse(result.isFailure)
    XCTAssertTrue(result.isSuccess)
    XCTAssertEqual(result.value, value)
    XCTAssertNil(result.error)
    XCTAssertNotNil(result.result)
    XCTAssertNotNil(result.description)
    
    switch result {
    case let .success(value):
      XCTAssertEqual(value, value)
    case let .failure(error):
      XCTFail("Result should be success \(error)")
    }
  }
  
  func testResultFailure() {
    
    let result = Result<Int, QminderError>(.apiKeyNotSet)
    
    XCTAssertTrue(result.isFailure)
    XCTAssertFalse(result.isSuccess)
    XCTAssertNil(result.value)
    XCTAssertNotNil(result.error)
    XCTAssertNotNil(result.result)
    XCTAssertNotNil(result.description)
    
    switch result {
    case .success:
      XCTFail("Result should be failure")
    case let .failure(error):
      switch error {
      case .apiKeyNotSet:
        print("Error set correctly")
      default:
        XCTFail("Error not correctly set")
      }
    }
  }
}
