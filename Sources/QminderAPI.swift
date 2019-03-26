//
//  QminderAPI.swift
//  Pods
//
//  Created by Qminder on 24/10/2016.
//
//

import Foundation

/// Qminder API
public struct QminderAPI: QminderAPIProtocol {
  
  /// Qminder API key
  private var apiKey: String?
  
  /// Qminder API address
  private var serverAddress: String
  
  /// Queue to return result in
  private var queue = DispatchQueue.main
  
  public init(apiKey: String? = nil, serverAddress: String = "https://api.qminder.com/v1") {
    self.apiKey = apiKey
    self.serverAddress = serverAddress
  }
  
  public func getLocationsList(completion: @escaping (Result<[Location], QminderError>) -> Void) {
    fetch(.locations, decodingType: Locations.self) { completion($0) }
  }
  
  public func getLocationDetails(locationId: Int,
                                 completion: @escaping (Result<Location, QminderError>) -> Void) {
    fetch(.location(locationId), decodingType: Location.self) { completion($0) }
  }
  
  public func getLocationLines(locationId: Int, completion: @escaping (Result<[Line], QminderError>) -> Void) {
    fetch(.lines(locationId), decodingType: Lines.self) { completion($0) }
  }
  
  public func getLocationUsers(locationId: Int, completion: @escaping (Result<[User], QminderError>) -> Void) {
    fetch(.users(locationId), decodingType: Users.self) { completion($0) }
  }
  
  public func getLocationDesks(locationId: Int, completion: @escaping (Result<[Desk], QminderError>) -> Void) {
    fetch(.desks(locationId), decodingType: Desks.self) { completion($0) }
  }
  
  public func getLineDetails(lineId: Int, completion: @escaping (Result<Line, QminderError>) -> Void) {
    fetch(.line(lineId), decodingType: Line.self) { completion($0) }
  }
  
  public func searchTickets(locationId: Int? = nil, lineId: Set<Int>? = nil, status: Set<Status>? = nil,
                            callerId: Int? = nil, minCreatedTimestamp: Int? = nil, maxCreatedTimestamp: Int? = nil,
                            minCalledTimestamp: Int? = nil, maxCalledTimestamp: Int? = nil,
                            limit: Int? = nil, order: String? = nil, responseScope: Set<String>? = nil,
                            completion: @escaping (Result<[Ticket], QminderError>) -> Void) {
    
    var parameters = [String: Any]()
    
    parameters.set(value: locationId, forKey: "location")
    parameters.set(value: lineId?.compactMap({ String($0) }).joined(separator: ","), forKey: "line")
    parameters.set(value: status?.compactMap({ $0.rawValue }).joined(separator: ","), forKey: "status")
    parameters.set(value: callerId, forKey: "caller")
    parameters.set(value: minCreatedTimestamp, forKey: "minCreated")
    parameters.set(value: maxCreatedTimestamp, forKey: "maxCreated")
    parameters.set(value: minCalledTimestamp, forKey: "minCalled")
    parameters.set(value: maxCalledTimestamp, forKey: "maxCalled")
    parameters.set(value: limit, forKey: "limit")
    parameters.set(value: order, forKey: "order")
    parameters.set(value: responseScope?.compactMap({ String($0) }).joined(separator: ","), forKey: "responseScope")
    
    fetch(.tickets(parameters), decodingType: Tickets.self) { completion($0) }
  }
  
  public func getTicketDetails(ticketId: String, completion: @escaping (Result<Ticket, QminderError>) -> Void) {
    fetch(.ticket(ticketId), decodingType: Ticket.self) { completion($0) }
  }
  
  public func getUserDetails(userId: Int, completion: @escaping (Result<User, QminderError>) -> Void) {
    fetch(.user(userId), decodingType: User.self) { completion($0) }
  }
  
  public func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode, QminderError>) -> Void) {
    fetch(.tvCode, decodingType: TVPairingCode.self) { completion($0) }
  }
  
  public func pairTV(code: String,
                     secret: String,
                     completion: @escaping (Result<TVAPIData, QminderError>) -> Void) {
    fetch(.tvPairingStatus(code, ["secret": secret]), decodingType: TVAPIData.self) { completion($0) }
  }
  
  public func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>) -> Void) {
    fetch(.tvDetails(id), decodingType: TVDevice.self) { completion($0) }
  }
  
  public func tvHeartbeat(id: Int, metadata: [String: Any],
                          completion: @escaping (Result<Void?, QminderError>) -> Void) {
    fetch(.tvHeartbeat(id, metadata)) { completion($0) }
  }
  
  public func tvEmptyState(id: Int, language: String,
                           completion: @escaping (Result<EmptyState, QminderError>) -> Void) {
    fetch(.tvEmptyState(id, ["language": language]), decodingType: EmptyState.self) { completion($0) }
  }
}
  
private extension QminderAPI {
  /**
   Fetch with responsable data
   
   - Parameters:
     - endPoint: Qminder API endpoint
     - decodingType: Decoding data type
     - completion: Closure called when data is retrieved correctly
  */
  func fetch<T: ResponsableWithData>(_ endPoint: QminderAPIEndpoint, decodingType: T.Type,
                                     _ completion: @escaping (Result<T.Data, QminderError>) -> Void) {
    performRequestWith(endPoint) { result in
      switch result {
      case let .success(data):
        completion(data.decode(decodingType))
      case let .failure(error):
        completion(Result(error))
      }
    }
  }
  
  /**
   Fetch with responsable
   
   - Parameters:
     - endPoint: Qminder API endpoint
     - decodingType: Decoding data type
     - completion: Closure called when data is retrieved correctly
  */
  func fetch<T: Responsable>(_ endPoint: QminderAPIEndpoint, decodingType: T.Type,
                             _ completion: @escaping (Result<T, QminderError>) -> Void) {
    performRequestWith(endPoint) { result in
      switch result {
      case let .success(data):
        completion(data.decode(decodingType))
      case let .failure(error):
        completion(Result(error))
      }
    }
  }
  
  /**
   Fetch from API
   
   - Parameters:
     - endPoint: Qminder API endpoint
     - completion: Closure called when data is retrieved correctly
  */
  func fetch(_ endPoint: QminderAPIEndpoint,
             _ completion: @escaping (Result<Void?, QminderError>) -> Void) {
    performRequestWith(endPoint) { result in
      switch result {
      case .success:
        completion(Result.success(nil))
      case let .failure(error):
        completion(Result(error))
      }
    }
  }
  
  /**
   Perform request
   
   - Parameters:
     - endPoint: Qminder API endpoint
     - completion: Closure called when data is retrieved correctly
  */
  func performRequestWith(_ endPoint: QminderAPIEndpoint,
                          _ completion: @escaping (Result<Data, QminderError>) -> Void) {
    do {
      let request = try endPoint.request(serverAddress: serverAddress, apiKey: apiKey)
      
      request.printCurlString()
      
      URLSession.shared.dataTask(with: request) { data, response, error in
        self.queue.async {
          completion(self.parseResponse(data: data, response: response, error: error))
        }
      }.resume()
    } catch {
      completion(Result(error.qminderError))
    }
  }
  
  /**
   Parse response
   
   - Parameters:
     - data: Data
     - response: URL response
     - error: Error
   
   - Returns: Result of data or Qmidner Error
  */
  func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, QminderError> {
    if let error = error {
      return Result(.request(error))
    } else {
      
      guard let httpResponse = response as? HTTPURLResponse, let resultData = data else {
        return Result(.parseRequest)
      }
      
      if httpResponse.statusCode != 200 {
        return Result(.statusCode(httpResponse.statusCode))
      }
      
      return Result(resultData)
    }
    
  }
}
