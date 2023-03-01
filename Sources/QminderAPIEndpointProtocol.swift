//
//  QminderAPIEndpointProtocol.swift
//  QminderAPI
//
//  Created by Kristaps Grinbergs on 08/03/2018.
//  Copyright © 2018 Kristaps Grinbergs. All rights reserved.
//

import Foundation

/// Qminder API endpoint protocol
protocol QminderAPIEndpointProtocol {
    
    /// Endpoint path
    var path: String { get }
    
    /// Parameters
    var parameters: [String: Any] { get }
    
    /// HTTP methods
    var method: HTTPMethod { get }
    
    /// Encoding: none or JSON
    var encoding: ParameterEncoding { get }
}

extension QminderAPIEndpointProtocol {
    
    func requestUnauthorised(serverAddress: String) throws -> URLRequest {
        var url = URLComponents(string: "\(serverAddress)\(path)")!
        
        if encoding == .none {
            url.queryItems = parameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = method.rawValue
        
        if encoding == .json {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
        }
        
        return request
    }
    
    /**
     Create request
     */
    internal func request(serverAddress: String, apiKey: String?) throws -> URLRequest {
        var url = URLComponents(string: "\(serverAddress)\(path)")!
        
        if encoding == .none {
            url.queryItems = parameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = method.rawValue
        
        guard let key = apiKey else {
            throw QminderError.apiKeyNotSet
        }
        
        request.setValue(key, forHTTPHeaderField: "X-Qminder-REST-API-Key")
        
        if encoding == .json {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
        }
        
        return request
    }
}
