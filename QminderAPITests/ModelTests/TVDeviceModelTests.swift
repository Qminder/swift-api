//
//  TVDeviceModelTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 19/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class TVDeviceModelTests: ModelTests {
  
  private let tvDeviceId = Int.random
  private let tvDeviceName = String.random
  private let theme = String.random
  private let layout = String.random
  private let firstFeature = String.random
  private let secondFeature = String.random
  
  private let firstLineId = Int.random
  private let secondLineId = Int.random
  private let thirdLineId = Int.random
  
  private var tvDeviceData: [String: Any]!
  
  private func decodeToTVDevice() -> TVDevice? {
    do {
      return try tvDeviceData.decodeAs(TVDevice.self)
    } catch {
      print("Can't decode device", error)
      return nil
    }
  }
  
  override func setUp() {
    super.setUp()
    
    tvDeviceData = [
      "id": tvDeviceId,
      "name": tvDeviceName,
      "settings": [
        "lines": [
          firstLineId,
          secondLineId,
          thirdLineId],
        "clearTickets": "afterCalling",
        "notificationViewLineVisible": true
      ],
      "features": [firstFeature, secondFeature],
      "theme": theme,
      "layout": layout
    ]
  }
  
  func testTVDeviceModel() {
    let device = decodeToTVDevice()
    
    XCTAssertEqual(device?.id, tvDeviceId)
    XCTAssertEqual(device?.name, tvDeviceName)
    XCTAssertEqual(device?.theme, theme)
    XCTAssertEqual(device?.layout, layout)
    XCTAssertNotNil(device?.settings)
    XCTAssertEqual(device?.settings?.clearTickets, .afterCalling)
    XCTAssertTrue(device?.features?.contains(firstFeature) ?? false)
    XCTAssertTrue(device?.features?.contains(secondFeature) ?? false)
    
    guard let lines = device?.settings?.lines else {
      XCTFail("Can't get device lines")
      return
    }
    
    XCTAssertFalse(lines.isEmpty)
    XCTAssertTrue(lines.contains(where: { $0 == firstLineId }))
    XCTAssertTrue(lines.contains(where: { $0 == secondLineId }))
    XCTAssertTrue(lines.contains(where: { $0 == thirdLineId }))
  }
  
  func testWithoutSettings() {
    tvDeviceData["settings"] = nil
    
    let device = decodeToTVDevice()
  
    XCTAssertNil(device?.settings)
    XCTAssertNil(device?.settings?.lines)
  }
  
  func testnotificationViewLineVisible() {
    let device = decodeToTVDevice()
    
    guard let settings = device?.settings,
      let notificationViewLineVisible = settings.notificationViewLineVisible else {
      XCTFail("Can't get device settings and notificationViewLineVisible")
      return
    }
    
    XCTAssertTrue(notificationViewLineVisible)
  }
}
