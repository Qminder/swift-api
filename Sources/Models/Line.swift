//
//  Line.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 15/10/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Line protocol
public protocol Lineable {
  
  /// Line ID
  var id: Int { get }
  
  /// Line name
  var name: String { get }
  
  /// ID of the location this line belongs to
  var location: Int? { get }
}

/// Line Object
public struct Line: Lineable & Responsable & Codable {
  public var statusCode: Int?
  
  public let id: Int
  public let name: String
  public let location: Int?
}

/// Lines object
struct Lines: ResponsableWithData {
  
  static var dataContainer = \Lines.data
  
  /// Status code from API
  internal let statusCode: Int?
  
  /// Lines array
  let data: [Line]
}
