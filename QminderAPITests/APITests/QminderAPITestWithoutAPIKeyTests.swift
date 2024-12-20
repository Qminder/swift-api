//
//  QminderAPITestWithoutAPIKey.swift
//  QminderAPITests
//
//  Created by Kristaps Grinbergs on 12/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import XCTest

@testable import QminderAPI

class QminderAPITestWithoutAPIKeyTests: XCTestCase {
  /// Qminder API protocol
  var qminderAPI: QminderAPIProtocol!
  
  override func setUp() {
    super.setUp()
    
    qminderAPI = QminderAPI()
  }
  
  func testLocationListWithoutAPIKey() {
    wait { expectation in
      qminderAPI.getLocationsList { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          XCTFail("Should not be success because API key is not set \(value)")
        case let .failure(error):
          XCTAssertEqual(error, QminderError.apiKeyNotSet)
        }
        
        expectation.fulfill()
      }
    }
  }
}
