//
//  Status.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 01/02/2018.
//

import Foundation

/// Ticket status
public enum Status: String, Codable {
  /// New
  case new = "NEW"
  
  /// Called
  case called = "CALLED"
  
  /// Cancelled by clerk
  case cancelledByClerk = "CANCELLED_BY_CLERK"
  
  /// No Show
  case noShow = "NOSHOW"
  
  /// Served
  case served = "SERVED"
    
  case scheduled = "SCHEDULED"

  case schedulingCancelled = "SCHEDULING_CANCELLED"
}
