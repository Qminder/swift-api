//
//  QminderAPI.swift
//  Pods
//
//  Created by Qminder on 24/10/2016.
//
//

import Foundation

/// Qminder API
public struct QminderAPI: QminderAPIProtocolResponse {
  
  /// Qminder API key
  private var apiKey: String?
  
  /// Qminder API address
  private var serverAddress: String

  /// Qminder TV Pairing Code address
  private var tvPairingServerAddress: String
  
  /// Queue to return result in
  private var queue = DispatchQueue.main
  
  public init(apiKey: String? = nil,
              serverAddress: String = "https://api.qminder.com/v1",
              tvPairingServerAddress: String = "https://tv.qminder.com") {
    self.apiKey = apiKey
    self.serverAddress = serverAddress
    self.tvPairingServerAddress = tvPairingServerAddress
  }
  
  public func getLocationsList(completion: @escaping (Result<[Location], QminderError>) -> Void) {
    getLocationsList { result, _ in
      completion(result)
    }
  }
  
  public func getLocationsList(completion: @escaping (Result<[Location], QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.locations, decodingType: Locations.self) { result, response in
      completion(result, response)
    }
  }
    
  public func getLocationLines(locationId: Int, completion: @escaping (Result<[Line], QminderError>) -> Void) {
    getLocationLines(locationId: locationId) { result, _ in
      completion(result)
    }
  }
  
  public func getLocationLines(locationId: Int,
                               completion: @escaping (Result<[Line], QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.lines(locationId), decodingType: Lines.self) { result, response in
      completion(result, response)
    }
  }
  
  public func getLineDetails(lineId: Int, completion: @escaping (Result<Line, QminderError>) -> Void) {
    getLineDetails(lineId: lineId) { result, _ in
      completion(result)
    }
  }
  
  public func getLineDetails(lineId: Int,
                             completion: @escaping (Result<Line, QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.line(lineId), decodingType: Line.self) { result, response in
      completion(result, response)
    }
  }

  public func getTicketDetails(ticketId: String, completion: @escaping (Result<Ticket, QminderError>) -> Void) {
    getTicketDetails(ticketId: ticketId) { result, _ in
      completion(result)
    }
  }
  
  public func getTicketDetails(ticketId: String,
                               completion: @escaping (Result<Ticket, QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.ticket(ticketId), decodingType: Ticket.self) { result, response in
      completion(result, response)
    }
  }
  
  public func getUserDetails(userId: Int, completion: @escaping (Result<User, QminderError>) -> Void) {
    getUserDetails(userId: userId) { result, _ in
      completion(result)
    }
  }
  
  public func getUserDetails(userId: Int,
                             completion: @escaping (Result<User, QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.user(userId), decodingType: User.self) { result, response in
      completion(result, response)
    }
  }
  
  public func getPairingCodeAndSecret(completion: @escaping (Result<TVPairingCode, QminderError>) -> Void) {
    getPairingCodeAndSecret { result, _ in
      completion(result)
    }
  }
  
  public func getPairingCodeAndSecret(
    completion: @escaping (Result<TVPairingCode, QminderError>, HTTPURLResponse?) -> Void) {
    fetchTvPairing(.tvCode, decodingType: TVPairingCode.self) { result, response in
      completion(result, response)
    }
  }
  
  public func pairTV(code: String,
                     secret: String,
                     completion: @escaping (Result<TVAPIData, QminderError>) -> Void) {
    pairTV(code: code, secret: secret) { result, _ in
      completion(result)
    }
  }
  
  public func pairTV(code: String,
                     secret: String,
                     completion: @escaping (Result<TVAPIData, QminderError>, HTTPURLResponse?) -> Void) {
    fetchTvPairing(.tvPairingStatus(code, ["secret": secret]), decodingType: TVAPIData.self) { result, response in
      completion(result, response)
    }
  }
  
  public func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>) -> Void) {
    tvDetails(id: id) { result, _ in
      completion(result)
    }
  }
  
  public func tvDetails(id: Int, completion: @escaping (Result<TVDevice, QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.tvDetails(id), decodingType: TVDevice.self) { result, response in
      completion(result, response)
    }
  }
  
  public func tvHeartbeat(id: Int, metadata: [String: Any],
                          completion: @escaping (Result<Void?, QminderError>) -> Void) {
    tvHeartbeat(id: id, metadata: metadata) { result, _ in
      completion(result)
    }
  }
  
  public func tvHeartbeat(id: Int, metadata: [String: Any],
                          completion: @escaping (Result<Void?, QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.tvHeartbeat(id, metadata)) { result, response in
      completion(result, response)
    }
  }
  
  public func tvEmptyState(id: Int, language: String,
                           completion: @escaping (Result<EmptyState, QminderError>) -> Void) {
    tvEmptyState(id: id, language: language) { result, _ in
      completion(result)
    }
  }
  
  public func tvEmptyState(id: Int, language: String,
                           completion: @escaping (Result<EmptyState, QminderError>, HTTPURLResponse?) -> Void) {
    fetch(.tvEmptyState(id, ["language": language]), decodingType: EmptyState.self) { result, response in
      completion(result, response)
    }
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
                                     _ completion: @escaping (Result<T.Data, QminderError>, HTTPURLResponse?) -> Void) {
    performRequestWith(endPoint) { result, response in
      switch result {
      case let .success(data):
        completion(data.decode(decodingType), response)
      case let .failure(error):
        completion(Result(error), response)
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
                             _ completion: @escaping (Result<T, QminderError>, HTTPURLResponse?) -> Void) {
    performRequestWith(endPoint) { result, response in
      switch result {
      case let .success(data):
        completion(data.decode(decodingType), response)
      case let .failure(error):
        completion(Result(error), response)
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
             _ completion: @escaping (Result<Void?, QminderError>, HTTPURLResponse?) -> Void) {
    performRequestWith(endPoint) { result, response in
      switch result {
      case .success:
        completion(Result.success(nil), response)
      case let .failure(error):
        completion(Result(error), response)
      }
    }
  }

  /**
    Fetch tv pairing endpoint with responsable
    
    - Parameters:
      - endPoint: Qminder tv pairing code endpoint
      - decodingType: Decoding data type
      - completion: Closure called when data is retrieved correctly
     */
  func fetchTvPairing<T: Responsable>(_ endPoint: QminderAPIEndpoint, decodingType: T.Type,
                                      _ completion: @escaping (Result<T, QminderError>, HTTPURLResponse?) -> Void) {
      performTvPairingRequestWith(endPoint) { result, response in
          switch result {
          case let .success(data):
              completion(data.decode(decodingType), response)
          case let .failure(error):
              completion(Result(error), response)
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
                          _ completion: @escaping (Result<Data, QminderError>, HTTPURLResponse?) -> Void) {
    do {
      let request = try endPoint.request(serverAddress: serverAddress, apiKey: apiKey)
      
      URLSession.shared.dataTask(with: request) { data, response, error in
        let httpURLResponse = response as? HTTPURLResponse
        self.queue.async {
          completion(self.parseResponse(data: data,
                                        response: response,
                                        error: error),
                     httpURLResponse)
        }
      }.resume()
    } catch {
      completion(Result(error.qminderError), nil)
    }
  }

  /**
   Perform tv pairing code request
   
   - Parameters:
     - endPoint: Qminder tv pairing code endpoint
     - completion: Closure called when data is retrieved correctly
  */
  func performTvPairingRequestWith(_ endPoint: QminderAPIEndpoint,
                                   _ completion: @escaping (Result<Data, QminderError>, HTTPURLResponse?) -> Void) {
    do {
      let request = try endPoint.requestUnauthorised(serverAddress: tvPairingServerAddress)
      
      URLSession.shared.dataTask(with: request) { data, response, error in
        let httpURLResponse = response as? HTTPURLResponse
        self.queue.async {
          completion(self.parseResponse(data: data,
                                        response: response,
                                        error: error),
                     httpURLResponse)
        }
      }.resume()
    } catch {
      completion(Result(error.qminderError), nil)
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
