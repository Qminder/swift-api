//
//  QminderAPIProtocol.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 07/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder API protocol
public protocol QminderAPIProtocol {
  
  /// Intialize Qminder API
  ///
  /// - Parameters:
  ///   - apiKey: Qminder API key
  ///   - serverAddress: Optional server address (used for tests)
  init(apiKey: String?, serverAddress: String)
  
  // MARK: - Location
  /// Get location list
  ///
  /// - Parameter completion: Callback block what is executed when location list is received
  func getLocationsList(completion: @escaping (Result<[Location], QminderError>) -> Void)
  
  /// Get location details
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location data is received
  func getLocationDetails(locationId: Int, completion: @escaping (Result<Location, QminderError>) -> Void)
  
  /// Get Location Lines
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location lines is received
  func getLocationLines(locationId: Int, completion: @escaping (Result<[Line], QminderError>) -> Void)
  
  /// Get location users
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location users is received
  func getLocationUsers(locationId: Int, completion: @escaping (Result<[User], QminderError>) -> Void)
  
  /// Get location desks
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location users is received
  func getLocationDesks(locationId: Int, completion: @escaping (Result<[Desk], QminderError>) -> Void)
  
  // MARK: - Lines
  /// Get line details
  ///
  /// - Parameters:
  ///   - lineId: Line ID
  ///   - completion: Callback block what is executed when line data is received
  func getLineDetails(lineId: Int, completion: @escaping (Result<Line, QminderError>) -> Void)
  
  // MARK: - Tickets
  // swiftlint:disable function_parameter_count
  /// Search tickets
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
                     completion: @escaping (Result<[Ticket], QminderError>) -> Void)
  
  /// Get ticket details
  ///
  /// - Parameters:
  ///   - ticketId: Ticket ID
  ///   - completion: Callback block when ticket details are received
  func getTicketDetails(ticketId: String, completion: @escaping (Result<Ticket, QminderError>) -> Void)
  
  // MARK: - Users
  /// Get user details
  ///
  /// - Parameters:
  ///   - userId: User ID
  ///   - completion: Callback block when user details are received
  func getUserDetails(userId: Int, completion: @escaping (Result<User, QminderError>) -> Void)
  
  // MARK: - Devices
  /// Get pairing code and secred key
  ///
  /// - Parameter completion: Callback block what is executed when pairing code and secret key is received from server
  func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode, QminderError>) -> Void)
  
  /// Pair TV with code
  ///
  /// - Parameters:
  ///   - code: Pairing code
  ///   - secret: Secret key
  ///   - completion: Callback block when pairing is done on server:
  func pairTV(code: String, secret: String, completion: @escaping (Result<TVAPIData, QminderError>) -> Void)
  
  /// Get a details of a TV
  ///
  /// - Parameters:
  ///   - id: TV ID
  ///   - completion: Callback block when TV details are received
  func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>) -> Void)
  
  /// Update the heartbeat of the TV and add optional metadata in JSON format
  ///
  /// - Parameters:
  ///   - id: TV ID
  ///   - metadata: Dictionary of metadata to send with heartbeat
  ///   - completion: Callback block when TV heartbeat is received
  func tvHeartbeat(id: Int,
                   metadata: [String: Any],
                   completion: @escaping (Result<Void?, QminderError>) -> Void)
  
  /// Empty state text message for TV
  ///
  /// - Parameters:
  ///   - id: TV ID
  ///   - language: Language
  ///   - completion: Callback block when empty state is received
  func tvEmptyState(id: Int,
                    language: String,
                    completion: @escaping (Result<EmptyState, QminderError>) -> Void)
}

extension QminderAPIProtocol {
  
  public func searchTickets(locationId: Int? = nil, lineId: Set<Int>? = nil,
                            status: Set<Status>? = nil, callerId: Int? = nil,
                            minCreatedTimestamp: Int? = nil, maxCreatedTimestamp: Int? = nil,
                            minCalledTimestamp: Int? = nil, maxCalledTimestamp: Int? = nil,
                            limit: Int? = nil, order: String? = nil,
                            responseScope: Set<String>? = nil,
                            completion: @escaping (Result<[Ticket], QminderError>) -> Void) {
    searchTickets(locationId: locationId,
                  lineId: lineId,
                  status: status,
                  callerId: callerId,
                  minCreatedTimestamp: minCreatedTimestamp,
                  maxCreatedTimestamp: maxCreatedTimestamp,
                  minCalledTimestamp: minCalledTimestamp,
                  maxCalledTimestamp: maxCalledTimestamp,
                  limit: limit,
                  order: order,
                  responseScope: responseScope,
                  completion: completion)
  }
}
