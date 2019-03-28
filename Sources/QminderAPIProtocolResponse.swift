//
//  QminderAPIProtocolResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/03/2019.
//  Copyright © 2019 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder API protocol
public protocol QminderAPIProtocolResponse: QminderAPIProtocol {
  
  // MARK: - Location
  /// Get location list with response
  ///
  /// - Parameter completion: Callback block what is executed when location list is received
  func getLocationsList(completion: @escaping (Result<[Location], QminderError>, HTTPURLResponse?) -> Void)
  
  /// Get location details with response
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location data is received
  func getLocationDetails(locationId: Int,
                          completion: @escaping (Result<Location, QminderError>, HTTPURLResponse?) -> Void)
  
  /// Get Location Lines with response
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location lines is received
  func getLocationLines(locationId: Int,
                        completion: @escaping (Result<[Line], QminderError>, HTTPURLResponse?) -> Void)
  
  /// Get location users with response
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location users is received
  func getLocationUsers(locationId: Int,
                        completion: @escaping (Result<[User], QminderError>, HTTPURLResponse?) -> Void)
  
  /// Get location desks with response
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location users is received
  func getLocationDesks(locationId: Int,
                        completion: @escaping (Result<[Desk], QminderError>, HTTPURLResponse?) -> Void)
  
  // MARK: - Lines
  /// Get line details with response
  ///
  /// - Parameters:
  ///   - lineId: Line ID
  ///   - completion: Callback block what is executed when line data is received
  func getLineDetails(lineId: Int,
                      completion: @escaping (Result<Line, QminderError>, HTTPURLResponse?) -> Void)
  
  // MARK: - Tickets
  // swiftlint:disable function_parameter_count
  
  /// Search tickets with response
  ///
  /// - Parameters:
  ///   - locationId: Optional parameter for searching tickets in specified location
  ///   - lineId: Optional array of line ID's
  ///   - status: Optional array of enum statuses
  ///   - callerId: Optional parameter for searching tickets which were called by specified user ID
  ///   - minCreatedTimestamp: Optional parameter for searching tickets which are created after specified time
  ///   - maxCreatedTimestamp: Optional parameter for searching tickets which are created before specified time
  ///   - minCalledTimestamp: Optional parameter for searching tickets which are called after specified time
  ///   - maxCalledTimestamp: Optional parameter for searching tickets which are called before specified time
  ///   - limit: Optional parameter for limiting number of search results. If no limit is specified, 1000 will be used
  ///   - order: Optional parameter for ordering results
  ///   - responseScope: Optional parameter for additional details about the found tickets
  ///   - completion: Callback block executed when tickets are received back
  func searchTickets(locationId: Int?, lineId: Set<Int>?, status: Set<Status>?,
                     callerId: Int?, minCreatedTimestamp: Int?, maxCreatedTimestamp: Int?,
                     minCalledTimestamp: Int?, maxCalledTimestamp: Int?,
                     limit: Int?, order: String?, responseScope: Set<String>?,
                     completion: @escaping (Result<[Ticket], QminderError>, HTTPURLResponse?) -> Void)
  
  /// Get ticket details with response
  ///
  /// - Parameters:
  ///   - ticketId: Ticket ID
  ///   - completion: Callback block when ticket details are received
  func getTicketDetails(ticketId: String,
                        completion: @escaping (Result<Ticket, QminderError>, HTTPURLResponse?) -> Void)
  
  // MARK: - Users
  /// Get user details with response
  ///
  /// - Parameters:
  ///   - userId: User ID
  ///   - completion: Callback block when user details are received
  func getUserDetails(userId: Int, completion: @escaping (Result<User, QminderError>, HTTPURLResponse?) -> Void)
  
  // MARK: - Devices
  /// Get pairing code and secred key with response
  ///
  /// - Parameter completion: Callback block what is executed when pairing code and secret key is received from server
  func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode, QminderError>, HTTPURLResponse?) -> Void)
  
  /// Pair TV with code with return response
  ///
  /// - Parameters:
  ///   - code: Pairing code
  ///   - secret: Secret key
  ///   - completion: Callback block when pairing is done on server:
  func pairTV(code: String, secret: String,
              completion: @escaping (Result<TVAPIData, QminderError>, HTTPURLResponse?) -> Void)
  
  /// Get a details of a TV with response
  ///
  /// - Parameters:
  ///   - id: TV ID
  ///   - completion: Callback block when TV details are received
  func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>, HTTPURLResponse?) -> Void)
  
  /// Update the heartbeat of the TV and add optional metadata in JSON format with response
  ///
  /// - Parameters:
  ///   - id: TV ID
  ///   - metadata: Dictionary of metadata to send with heartbeat
  ///   - completion: Callback block when TV heartbeat is received
  func tvHeartbeat(id: Int,
                   metadata: [String: Any],
                   completion: @escaping (Result<Void?, QminderError>, HTTPURLResponse?) -> Void)
  
  /// Empty state text message for TV with response
  ///
  /// - Parameters:
  ///   - id: TV ID
  ///   - language: Language
  ///   - completion: Callback block when empty state is received
  func tvEmptyState(id: Int,
                    language: String,
                    completion: @escaping (Result<EmptyState, QminderError>, HTTPURLResponse?) -> Void)
}

extension QminderAPIProtocolResponse {
  
  /// Search tickets with response
  ///
  /// - Parameters:
  ///   - locationId: Optional parameter for searching tickets in specified location
  ///   - lineId: Optional array of line ID's
  ///   - status: Optional array of enum statuses
  ///   - callerId: Optional parameter for searching tickets which were called by specified user ID
  ///   - minCreatedTimestamp: Optional parameter for searching tickets which are created after specified time
  ///   - maxCreatedTimestamp: Optional parameter for searching tickets which are created before specified time
  ///   - minCalledTimestamp: Optional parameter for searching tickets which are called after specified time
  ///   - maxCalledTimestamp: Optional parameter for searching tickets which are called before specified time
  ///   - limit: Optional parameter for limiting number of search results. If no limit is specified, 1000 will be used
  ///   - order: Optional parameter for ordering results
  ///   - responseScope: Optional parameter for additional details about the found tickets
  ///   - completion: Callback block executed when tickets are received back
  public func searchTickets(locationId: Int? = nil,
                            lineId: Set<Int>? = nil,
                            status: Set<Status>? = nil,
                            callerId: Int? = nil,
                            minCreatedTimestamp: Int? = nil,
                            maxCreatedTimestamp: Int? = nil,
                            minCalledTimestamp: Int? = nil,
                            maxCalledTimestamp: Int? = nil,
                            limit: Int? = nil,
                            order: String? = nil,
                            responseScope: Set<String>? = nil,
                            completion: @escaping (Result<[Ticket], QminderError>, HTTPURLResponse?) -> Void) {
    searchTickets(locationId: locationId, lineId: lineId,
                  status: status, callerId: callerId,
                  minCreatedTimestamp: minCreatedTimestamp, maxCreatedTimestamp: maxCreatedTimestamp,
                  minCalledTimestamp: minCalledTimestamp, maxCalledTimestamp: maxCalledTimestamp,
                  limit: limit, order: order, responseScope: responseScope, completion: completion)
  }
}
