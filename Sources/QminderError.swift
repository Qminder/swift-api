//
//  Errors.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 05/12/2016.
//
//

import Foundation

/// Qminder API errors
public enum QminderError: Error {

  /// API key is not set
  case apiKeyNotSet
  
  /// Request error
  case request(Error)
  
  /// GraphQL error
  case graphQL(Error)

  /// GraphQL errors
  case graphQLErrors([Error])
  
  /// Cant parse object
  case unreadableObject
  
  /// Status code error
  case statusCode(Int)
  
  /// Can't parse to response
  case parseRequest
  
  /// Parsing error
  case parse
  
  /// Parsing with error
  case jsonParsing(Error)
}

extension Error {
  
  /// Qminder error representation
  var qminderError: QminderError {
    guard let error = self as? QminderError else {
      return QminderError.request(self)
    }
    
    return error
  }
}
