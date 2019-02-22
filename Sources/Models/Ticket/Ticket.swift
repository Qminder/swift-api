//
//  Ticket.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

// MARK: - Protocols

/// Ticket describing protocol
public protocol Ticketable: Codable {
  
  /// A unique ticket ID
  var id: String { get }
  
  /// Ticket number
  var number: Int? { get }
  
  /// Line ID
  var line: Int { get set }
  
  /// Source of the ticket.
  var source: Source { get }
  
  /// Ticket status
  var status: Status { get set }
  
  /// First name
  var firstName: String? { get set }
  
  /// Last name
  var lastName: String? { get set }
  
  /// Phone number
  var phoneNumber: Int? { get set }
  
  /// Email
  var email: String? { get set }
  
  /// Created date
  var created: Created { get }
  
  /// Served date
  var served: Served? { get set }
  
  /// Labels
  var labels: [Label]? { get set }
  
  /// Extra info
  var extra: [Extra]? { get set }
  
  /// Order after
  var orderAfter: Date? { get set }
  
  /// Ticket interactions
  var interactions: [Interaction]? { get set }
}

public extension Ticketable {
  
  /// Creted date
  var createdDate: Date {
    return created.date
  }
  
  /// Called date
  var calledDate: Date? {
    return calledInteraction?.start
  }
  
  /// Served date
  var servedDate: Date? {
    return served?.date
  }
  
  /// Called user ID
  var userCalledID: Int? {
    return calledInteraction?.user
  }
  
  /// Called Desk ID
  var calledDeskID: Int? {
    return calledInteraction?.desk
  }
  
  /// Called interaction
  private var calledInteraction: Interaction? {
    return interactions?.first(where: { $0.end == nil })
  }
}

// MARK: - Structs
/// Ticket mapping object
public struct Ticket: Ticketable, Responsable {
  
  public var statusCode: Int?
  
  public let id: String
  public let number: Int?
  public var line: Int
  public let source: Source
  public var status: Status
  public var firstName: String?
  public var lastName: String?
  public var phoneNumber: Int?
  public var email: String?
  public var created: Created
  public var served: Served?
  public var labels: [Label]?
  public var extra: [Extra]?
  public var orderAfter: Date?
  public var interactions: [Interaction]?
}
