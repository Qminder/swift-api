//
//  TVDeviceProtocol.swift
//  QminderAPI-iOS
//
//  Created by Kristaps Grinbergs on 10/09/2019.
//  Copyright © 2019 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// TV Device protocol
public protocol TVDeviceProtocol {
  
  /// Device ID
  var id: Int { get }
  
  /// Device name
  var name: String { get }
  
  /// Name of TV theme
  var theme: String { get }
  
  /// Name of TV layout
  var layout: String { get }
  
  /// Settings of the TV, only included when applicable
  var settings: Settings? { get }
  
  /// TV feature flags
  var features: [String]? { get }
}
