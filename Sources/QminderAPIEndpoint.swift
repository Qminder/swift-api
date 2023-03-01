//
//  QminderAPIEndpoint.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 08/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

enum QminderAPIEndpoint: QminderAPIEndpointProtocol {
    case locations
    case location(Int)
    case lines(Int)
    case users(Int)
    case desks(Int)
    case line(Int)
    case tickets([String: Any])
    case ticket(String)
    case user(Int)
    case tvCode
    case tvPairingStatus(String, [String: Any])
    case tvDetails(Int)
    case tvHeartbeat(Int, [String: Any])
    case tvEmptyState(Int, [String: Any])
    
    var path: String {
        switch self {
        case .locations:
            return "/locations/"
        case let .location(locationId):
            return "/locations/\(locationId)"
        case let .lines(locationId):
            return "/locations/\(locationId)/lines"
        case let .users(locationId):
            return "/locations/\(locationId)/users"
        case let .desks(locationId):
            return "/locations/\(locationId)/desks"
        case let .line(lineId):
            return "/lines/\(lineId)"
        case .tickets:
            return "/tickets/search"
        case let .ticket(ticketId):
            return "/tickets/\(ticketId)"
        case let .user(userId):
            return "/users/\(userId)"
        case .tvCode:
            return "/tv/code"
        case let .tvPairingStatus(code, _):
            return "/tv/code/\(code)"
        case let .tvDetails(tvId):
            return "/tv/\(tvId)"
        case let .tvHeartbeat(tvId, _):
            return "/tv/\(tvId)/heartbeat"
        case let .tvEmptyState(tvId, _):
            return "/tv/\(tvId)/emptystate"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .tickets(parameters), let .tvPairingStatus(_, parameters),
            let .tvHeartbeat(_, parameters), let .tvEmptyState(_, parameters) :
            return parameters
        default:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .tvHeartbeat:
            return .post
        default:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .tvHeartbeat:
            return .json
        default:
            return .none
        }
    }
}
