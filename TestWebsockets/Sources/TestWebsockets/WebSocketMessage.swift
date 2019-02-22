//
//  WebSocketMessage.swift
//  Async
//
//  Created by Kristaps Grinbergs on 11/05/2018.
//

import Foundation

/// Qminder Event type
public enum QminderEvent: String, CustomStringConvertible, CaseIterable {
  
  /// Ticket created
  case ticketCreated = "TICKET_CREATED"
  
  /// Ticket called
  case ticketCalled = "TICKET_CALLED"
  
  /// Ticke recalled
  case ticketRecalled = "TICKET_RECALLED"
  
  /// Ticket cancelled
  case ticketCancelled = "TICKET_CANCELLED"
  
  /// Ticket served
  case ticketServed = "TICKET_SERVED"
  
  /// Ticket changed
  case ticketChanged = "TICKET_CHANGED"
  
  /// Overview monitor change
  case overviewMonitorChange = "OVERVIEW_MONITOR_CHANGE"
  
  /// Lines changed
  case linesChanged = "LINES_CHANGED"
  
  public var description: String {
    return self.rawValue
  }
}

/// Websocket message model
struct WebsocketMessage: Codable {
  
  /// ID of websocket message
  var id: String
  
  /// Subscribe event
  var subscribe: String
  
  /// Event type enum representation
  var eventType: QminderEvent {
    return QminderEvent.init(rawValue: subscribe)!
  }
}
