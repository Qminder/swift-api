import Foundation
import QminderAPI

@discardableResult
public func prettyPrint<V, E: Swift.Error>(_ title: String, _ result: Result<V, E>) -> V? {
  print("-- \(title) --")
  
  switch result {
  case .success(let value):
    print(value)
  case .failure(let error):
    print(error)
  }
  
  print("")
  
  return result.value
}
