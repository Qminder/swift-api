//
//  LocationsAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class LocationsAPITests: QminderAPITests {
  
  func testLocationsList() {
    var locations: [Location]?
    var location: Location?
    
    wait { expectation in
      qminderAPI.getLocationsList { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          locations = value
          location = locations?.first
          
          expectation.fulfill()
        case let .failure(error):
          XCTFail("Can't get locations list \(error)")
        }
      }
    }
    
    XCTAssertNotNil(locations)
    
    XCTAssertNotNil(location)
    XCTAssertNotNil(location?.id)
    XCTAssertNotNil(location?.name)
    XCTAssertNotNil(location?.latitude)
    XCTAssertNotNil(location?.longitude)
  }
   
  func testLinesList() {
    var lines: [Line]?
    var line: Line?
    
    wait { expectation in
      qminderAPI.getLocationLines(locationId: locationId) { result in
        
        XCTAssertTrue(Thread.isMainThread)
        
        switch result {
        case let .success(value):
          lines = value
          line = lines?.first
          
          expectation.fulfill()
        case let .failure(error):
          XCTFail("Can't get lines list \(error)")
        }
      }
    }
    
    XCTAssertNotNil(lines)
    
    XCTAssertNotNil(line)
    XCTAssertNotNil(line?.id)
    XCTAssertNotNil(line?.name)
  }
}
