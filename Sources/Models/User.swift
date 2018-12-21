//
//  User.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//  Copyright © 2018 Qminder. All rights reserved.
//

import Foundation

/// User protocol
public protocol Userable {
  /// User ID
  var id: Int { get }
  
  /// Email address
  var email: String { get }
  
  /// First name
  var firstName: String { get }
  
  /// Last name
  var lastName: String { get }
  
  /// Selected desk number
  var desk: Int? { get }
  
  /// User roles
  var roles: [Role]? { get }
  
  /// User pictures
  var picture: [Picture]? { get }
}

/// User object
public struct User: Userable & Responsable & Codable {
  public var statusCode: Int?
  
  public let id: Int
  public let email: String
  public let firstName: String
  public let lastName: String
  public let desk: Int?
  public let roles: [Role]?
  public let picture: [Picture]?
}

/// User role object
public struct Role: Codable {
  
  /// User's role
  public let type: String?
  
  /// The identifier of the location where given role is applicable. Not applicable to all roles
  public let location: Int?
}

/// User image object
public struct Picture: Codable {
  
  /// Picture size
  public let size: String?
  
  /// Picture URL
  public let url: String?
}

/// Tickets object
struct Users: ResponsableWithData {
  
  static var dataContainer = \Users.data
  
  internal let statusCode: Int?
  let data: [User]
}
