//
//  Device.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/02/2017.
//
//

import Foundation

public protocol TVDeviceProtocol {
  var id: Int { get }
  var name: String { get }
  var theme: String { get }
  var layout: String { get }
  var settings: Settings? { get }
  var features: [String]? { get }
}

/// User object
public struct TVDevice: TVDeviceProtocol & Responsable {
  
  /// Status code from API
  public let statusCode: Int?

  /// Device ID
  public let id: Int
  
  /// Device name
  public let name: String
  
  /// Name of TV theme
  public let theme: String
  
  /// Name of TV layout
  public let layout: String
  
  /// Settings of the TV, only included when applicable
  public let settings: Settings?
  
  /// TV feature flags
  public let features: [String]?
}

public protocol TVSettingsProtocol {
  var selectedLine: Int? { get }
  var lines: Set<Int>? { get }
  var clearTickets: ClearTickets? { get }
  var notificationViewLineVisible: Bool? { get }
}

/// Created data object
public struct Settings: Codable {

  /// Selected line ID
  public let selectedLine: Int?
  
  /// Selected lines ID array
  public let lines: Set<Int>?
  
  /// Clear tickets
  public let clearTickets: ClearTickets?
  
  /// Show notification view line
  public let notificationViewLineVisible: Bool?
}
