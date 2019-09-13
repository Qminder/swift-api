//
//  TVSettingsProtocol.swift
//  QminderAPI-iOS
//
//  Created by Kristaps Grinbergs on 10/09/2019.
//  Copyright © 2019 Kristaps Grinbergs. All rights reserved.
//

import Foundation

public protocol TVSettingsProtocol {
  var selectedLine: Int? { get }
  var lines: Set<Int>? { get }
  var clearTickets: ClearTickets? { get }
  var notificationViewLineVisible: Bool? { get }
}
