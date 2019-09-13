//
//  Device.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/02/2017.
//
//

import Foundation

/// User object
public struct TVDevice: TVDeviceProtocol & Responsable {
  public let statusCode: Int?
  
  public let id: Int
  public let name: String
  public let theme: String
  public let layout: String
  public let settings: Settings?
  public let features: [String]?
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
