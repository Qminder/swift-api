//
//  QminderAPIProtocolResponse.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 28/03/2019.
//  Copyright © 2019 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder API protocol with returing also response
public protocol QminderAPIProtocolResponse: QminderAPIProtocol {
  
  // MARK: - Location
  /// Get location list with response
  ///
  /// - Parameter completion: Callback block what is executed when location list is received
  func getLocationsList(completion: @escaping (Result<[Location], QminderError>, HTTPURLResponse?) -> Void)
   
  /// Get Location Lines with response
  ///
  /// - Parameters:
  ///   - locationId: Location ID
  ///   - completion: Callback block what is executed when location lines is received
  func getLocationLines(locationId: Int,
                        completion: @escaping (Result<[Line], QminderError>, HTTPURLResponse?) -> Void)
  
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
