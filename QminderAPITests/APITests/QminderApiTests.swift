//
//  QminderAPITests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import XCTest

@testable import QminderAPI

class QminderAPITests: XCTestCase {
  /// Qminder API protocol
  var qminderAPI: QminderAPIProtocol!
  
  /// Location ID
  let locationId = Int(ProcessInfo.processInfo.environment["QMINDER_LOCATION_ID"]!)!
  
  /// Line ID
  let lineId = Int(ProcessInfo.processInfo.environment["QMINDER_LINE_ID"]!)!
  
  /// User ID
  let userID = Int(ProcessInfo.processInfo.environment["QMINDER_USER_ID"]!)!
  
  /// TV ID
  let tvID = Int(ProcessInfo.processInfo.environment["QMINDER_TV_ID"]!)!
  
  override func setUp() {
    super.setUp()
    
    if let apiKey = ProcessInfo.processInfo.environment["QMINDER_API_KEY"] {
      qminderAPI = QminderAPI(apiKey: apiKey)
    }
  }
}
