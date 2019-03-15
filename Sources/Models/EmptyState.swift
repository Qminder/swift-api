//
//  EmptyState.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 27/07/2017.
//
//

import Foundation

/// Empty state layout
public enum EmptyStateLayout: String, Codable {
  
  /// TV connected
  case connected
  
  /// Good morning
  case goodMorning
  
  /// Sign-in with iPad
  case signIniPad
  
  /// Closed
  case closed
  
  /// Sign-in without iPad
  case signIn
  
  /// Other (not specified)
  case other
  
  public init?(rawValue: String) {
    switch rawValue.lowercased() {
    case "connected":
      self = .connected
    case "goodmorning":
      self = .goodMorning
    case "signinipad":
      self = .signIniPad
    case "signin":
      self = .signIn
    case "closed":
      self = .closed
    default:
      self = .other
    }
  }
}

/// Empty state object
public struct EmptyState: Responsable {
  
  public let statusCode: Int?
  
  /// Empty state layout
  public let layout: EmptyStateLayout
  
  /// Empty state message
  public let message: String
}
