import Foundation
import QminderAPI

public func prettyPrint<V: Codable, E: Error>(_ title: String, _ result: Result<V, E>){
  print("-- \(title) --")
  
  switch result {
  case .success(let value):
    print(value)
  case .failure(let error):
    print(error)
  }
  
  print("")
}
