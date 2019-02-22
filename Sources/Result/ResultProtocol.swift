import Foundation

/// A protocol that can be used to constrain associated types as `Result`.
public protocol ResultProtocol: CustomStringConvertible {
  
  /// Result value
	associatedtype Value
  
  /// Result Error
	associatedtype Error: Swift.Error

  /**
   Init Result with value
   
   - Parameters:
     - value: Generic type Value
  */
	init(_ value: Value)
  
  /**
   Init Result with error
   
   - Parameters:
     - error: Error protocol type
  */
	init(_ error: Error)
	
  /// Result
	var result: Result<Value, Error> { get }
}

public extension Result {
  
  /// Constructs a success wrapping a `value`.
  init(_ value: Success) {
    self = .success(value)
  }
  
  /// Constructs a failure wrapping an `error`.
  init(_ error: Failure) {
    self = .failure(error)
  }
  
	/// Returns the value if self represents a success, `nil` otherwise.
  var value: Success? {
    switch self {
    case let .success(value):
      return value
    case .failure:
      return nil
    }
	}
	
	/// Returns the error if self represents a failure, `nil` otherwise.
  var error: Error? {
		switch self {
		case .success:
      return nil
		case let .failure(error):
      return error
		}
	}

  /// Returns `true` if the result is a success, `false` otherwise.
  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }

  /// Returns `true` if the result is a failure, `false` otherwise.
  var isFailure: Bool {
    return !isSuccess
  }
  
  /// Result value
  var result: Result<Success, Failure> {
    return self
  }
  
  // MARK: CustomDebugStringConvertible
  var description: String {
    switch self {
    case let .success(value): return ".success(\(value))"
    case let .failure(error): return ".failure(\(error))"
    }
  }
}
