//
//  Desk.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 29/01/2018.
//

import Foundation

/// Desk protocol
public protocol Deskable {
  
  /// Desk ID
  var id: Int { get }
  
  /// Desk name
  var name: String { get }
}

/// Desk object
public struct Desk: Deskable & Codable {
  public let id: Int
  public let name: String
}

protocol DesksResponsable: Responsable {
  /// Data with API request
  associatedtype Data
  
  /// Desks from API
  var desks: [Data] { get }
}

/// Desks object
struct Desks: ResponsableWithData {
  
  static var dataContainer = \Desks.desks
  
  internal let statusCode: Int?
  let desks: [Desk]
}
