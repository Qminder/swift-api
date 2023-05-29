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
    self = String((0..<length).compactMap {_ in letters.randomElement() })
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
