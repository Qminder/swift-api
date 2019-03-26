//
//  QminderEventsProtocol.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 10/05/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder Events protocol
public protocol QminderEventsProtocol {
  
  /// Class delegate
  var delegate: QminderEventsDelegate? { get set }
  
  /// Open websocket
  func openSocket()
  
  /// Reopen websocket
  func reOpenSocket()
  
  /// Close websocket connection
  func closeSocket()
  
  /// Subscribe to ticket event
  ///
  /// - Parameters:
  ///   - eventType: Event type to subscribe
  ///   - parameters: Dictionary of parameters
  ///   - callback: Callback executed when response got from Websocket
  func subscribe(toTicketEvent eventType: TicketWebsocketEvent,
                 parameters: [String: Any],
                 callback: @escaping (Result<Ticket, QminderError>) -> Void)
  
  /// Subscribe to device event
  ///
  /// - Parameters:
  ///   - eventType: Event type to subscribe
  ///   - parameters: Dictionary of parameters
  ///   - callback: Callback executed when response got from Websocket
  func subscribe(toDeviceEvent eventType: DeviceWebsocketEvent,
                 parameters: [String: Any],
                 callback: @escaping (Result<TVDevice?, QminderError>) -> Void)
  
  /// Subscribe to lines event
  ///
  /// - Parameters:
  ///   - eventType: Event type to subscribe
  ///   - parameters: Dictionary of parameters
  ///   - callback: Callback executed when response got from Websocket
  func subscribe(toLineEvent eventType: LineWebsocketEvent,
                 parameters: [String: Any],
                 callback: @escaping (Result<[Line], QminderError>) -> Void)
}
