//
//  Extensions.swift
//  Alamofire
//
//  Created by Kristaps Grinbergs on 26/09/2017.
//

import Foundation

public extension JSONDecoder {
  
  /// JSON decoder with milliseconds
  static let withMilliseconds: JSONDecoder = {
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({decoder -> Date in
      
      let container = try decoder.singleValueContainer()
      let dateStr = try container.decode(String.self)
      
      var tmpDate: Date?
      
      if dateStr.count == 17 {
        tmpDate = DateFormatter.ISO8601short.date(from: dateStr)
      } else if dateStr.count == 24 {
        tmpDate = DateFormatter.ISO8601Milliseconds.date(from: dateStr)
      } else {
        tmpDate = DateFormatter.ISO8601.date(from: dateStr)
      }
      
      guard let date = tmpDate else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
      }
      
      return date
    })
    
    return decoder
  }()
}

public extension DateFormatter {
  
  /// ISO-8601 date formatter without seconds
  static let ISO8601short: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
  
    return formatter
  }()
  
  /// ISO-8601 date formatter
  static let ISO8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    return formatter
  }()
  
  /// ISO-8601 with milliseconds date formatter
  static let ISO8601Milliseconds: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    return formatter
  }()
}

extension String {
  
  /**
   Create random string for subscription ID
   */
  init (withRandomLenght length: Int) {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomLength = UInt32(letters.count)
    
    let randomString: String = (0 ..< length).reduce(String()) { accum, _ in
      let randomOffset = arc4random_uniform(randomLength)
      let randomIndex = letters.index(letters.startIndex, offsetBy: Int(randomOffset))
      return accum.appending(String(letters[randomIndex]))
    }
    
    self = randomString
  }
}

public extension Dictionary where Key == String, Value == Any {
  /**
    Mutating Dictonary function to update/add value if it isn't nil
   
    - Parameters:
      - value: Value to set
      - key: Key to set to
  */
  mutating func set(value optionalValue: Any?, forKey key: String) {
    guard let value = optionalValue else { return }
    
    self[key] = value
  }
}

extension URLRequest: Loggable {
  
  /**
   Print curl String from request
  */
  public func printCurlString() {
    #if DEBUG
      log("\(curlString)")
    #endif
  }
  
  /// curl String
  public var curlString: String {
    var result = "curl -k "
    
    if let method = httpMethod {
      result += "-X \(method) \\\n"
    }
    
    if let headers = allHTTPHeaderFields {
      for (header, value) in headers {
        result += "-H \"\(header): \(value)\" \\\n"
      }
    }
    
    if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
      result += "-d '\(string)' \\\n"
    }
    
    if let url = url {
      result += url.absoluteString
    }
    
    return result
  }
}
