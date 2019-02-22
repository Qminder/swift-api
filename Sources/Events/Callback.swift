//
//  Callback.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 12/06/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder events callback
internal enum Callback {
  
  /// Ticket callback
  case ticket((Result<Ticket, QminderError>) -> Void)
  
  /// Device callback
  case device((Result<TVDevice?, QminderError>) -> Void)
  
  /// Line callback
  case line((Result<[Line], QminderError>) -> Void)
}
