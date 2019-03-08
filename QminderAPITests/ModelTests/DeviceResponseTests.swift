//
//  DeviceResponseTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 28/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

import QminderAPI

class DeviceResponseTests: ModelTests {
  
  func testDeviceResponse() {
    
    let subScriptionId = String(Int.random)
    let messageId = Int.random
    let deviceId = Int.random
    let deviceName = String.random
    let themeName = String.random
    let layout = String.random
    let feature = String.random
    
    let tvDeviceResponseData: [String: Any] = [
      "subscriptionId": subScriptionId,
      "messageId": messageId,
      "data": [
        "statusCode": 200,
        "id": deviceId,
        "name": deviceName,
        "settings": [
          "lines": [1, 2, 3],
          "clearTickets": "afterCalling"
        ],
        "features": [feature],
        "theme": themeName,
        "layout": layout
      ]
    ]
    let deviceResponse = try? tvDeviceResponseData.decodeAs(DeviceEventResponse.self)
    
    XCTAssertEqual(deviceResponse?.subscriptionId, subScriptionId)
    XCTAssertEqual(deviceResponse?.messageId, messageId)
    
    guard let device = deviceResponse?.data else {
      XCTFail("Can't parse data to ticket")
      return
    }
    
    XCTAssertEqual(device.id, deviceId)
    XCTAssertEqual(device.name, deviceName)
    XCTAssertEqual(device.theme, themeName)
    XCTAssertEqual(device.layout, layout)
    XCTAssertNotNil(device.settings)
    XCTAssertEqual(device.settings?.clearTickets, .afterCalling)
    XCTAssertTrue(device.features?.count == 1)
    XCTAssertEqual(device.features?.first, feature)
  }
}
