//
//  Events.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 28/10/2016.
//
//

import Foundation

import Starscream

/// Qminder Events works with Qminder Websockets
public class QminderEvents: QminderEventsProtocol, Loggable {

  public weak var delegate: QminderEventsDelegate?

  /// Qminder events constants
  fileprivate enum Constants {
    
    /// Qminder close code
    static let websocketReservedCloseCode = UInt16(1099)
    
    /// Ping interval
    static let pingInterval = 1
    
    /// Reconnect interval
    static let reconnectInterval = 5
  }

  /// JSON decoder with milliseconds
  fileprivate let jsonDecoderWithMilliseconds = JSONDecoder.withMilliseconds
  
  /// Message history to hold sent messages to Websocket
  fileprivate var messageHistory = [String]()
  
  /// Message queue to hold not sent messages to Websocket
  fileprivate var messageQueue = [WebsocketMessage]()
  
  /// Callback map to call specific block when data is received from Websocket
  fileprivate var callbackMap = [String: Callback]()
  
  /// Is currently connection being opened (Boolean)
  fileprivate var openingConnection = false
  
  /// Is connection closed
  fileprivate var connectionClosed = false
  
  /// Websocket object
  fileprivate var socket: WebSocket!
  
  /// Ping queue
  fileprivate let pingQueue = DispatchQueue(label: "com.qminder.pingQueue")
  
  /// Reconnect queue
  fileprivate let reconnectQueue = DispatchQueue(label: "com.qminder.reconnectQueue")
  
  /// Initalise Qminder events
  ///
  /// - Parameters:
  ///   - serverAddress: Server address
  ///   - apiKey: Optional API key
  public init(serverAddress: String = "wss://api.qminder.com", apiKey: String? = nil) {
    var websocketAddress = serverAddress
    if let apiKey = apiKey {
      websocketAddress += "/events?rest-api-key=\(apiKey)"
    }
    
    let url = URL(string: websocketAddress)!
    self.socket = WebSocket(url: url)
    self.socket?.delegate = self
  }
  
  public func openSocket() {
    if !openingConnection {
      log("openSocket")
      openingConnection = true
      connectionClosed = false
      self.socket.connect()
    }
  }
  
  public func reOpenSocket() {
    if !self.socket.isConnected {
      log("reOpenSocket")
      openSocket()
    }
  }
  
  public func closeSocket() {
    log("close Socket")
    
    messageHistory.removeAll()
    messageQueue.removeAll()
    
    self.connectionClosed = true
    self.socket.disconnect(closeCode: Constants.websocketReservedCloseCode)
  }

  public func subscribe(toTicketEvent eventType: TicketWebsocketEvent,
                        parameters: [String: Any],
                        callback: @escaping (Result<Ticket, QminderError>) -> Void) {
    
    guard let (message, subscriptionId) = parseParameters(eventType: .ticket(eventType), parameters: parameters) else {
      callback(Result.failure(QminderError.parse))
      return
    }
    
    sendMessageToWebsocket(subscriptionId: subscriptionId,
                           eventType: .ticket(eventType),
                           message: message,
                           callback: .ticket(callback))
  }

  public func subscribe(toDeviceEvent eventType: DeviceWebsocketEvent,
                        parameters: [String: Any],
                        callback: @escaping (Result<TVDevice?, QminderError>) -> Void) {
    
    guard let (message, subscriptionId) = parseParameters(eventType: .device(eventType), parameters: parameters) else {
      callback(Result.failure(QminderError.parse))
      return
    }
    
    sendMessageToWebsocket(subscriptionId: subscriptionId,
                           eventType: .device(eventType),
                           message: message,
                           callback: .device(callback))
  }
  
  public func subscribe(toLineEvent eventType: LineWebsocketEvent,
                        parameters: [String: Any],
                        callback: @escaping (Result<[Line], QminderError>) -> Void) {
    
    guard let (message, subscriptionId) = parseParameters(eventType: .line(eventType), parameters: parameters) else {
      callback(Result.failure(QminderError.parse))
      return
    }
    
    sendMessageToWebsocket(subscriptionId: subscriptionId,
                           eventType: .line(eventType),
                           message: message,
                           callback: .line(callback))
  }
  
  /// Send message to websocket
  ///
  /// - Parameters:
  ///   - subscriptionId: Subscription ID
  ///   - eventType: Qminder event type
  ///   - message: Message to send
  ///   - callback: Callback execute when websocket event has accoured
  private func sendMessageToWebsocket(subscriptionId: String,
                                      eventType: QminderWebsocketEvent,
                                      message: String,
                                      callback: Callback) {
    if socket.isConnected {
      sendMessage(subscriptionId: subscriptionId, eventType: eventType, messageToSend: message, callback: callback)
      
      messageHistory.append(message)
    } else {
      messageQueue.append(WebsocketMessage(subscriptionId: subscriptionId,
                                           eventType: eventType,
                                           messageToSend: message,
                                           callback: callback))
      
      if !openingConnection {
        openSocket()
      }
    }
  }
  
  /// Parse parameters
  ///
  /// - Parameters:
  ///   - eventType: Qminder event type
  ///   - parameters: Parameters
  private func parseParameters(eventType: QminderWebsocketEvent,
                               parameters: [String: Any]) -> (message: String, subscriptionId: String)? {
    
    var parameters = parameters
    let subscriptionId = String(withRandomLenght: 30)
    
    parameters["id"] = subscriptionId
    parameters["subscribe"] = eventType.description
    
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
      
      guard let message = String(data: jsonData, encoding: .utf8) else {
        return nil
      }
      
      return (message, subscriptionId)
    } catch {
      return nil
    }
  }
  
  /// Send ping
  private func sendPing() {
    guard socket.isConnected else { return }
    
    socket.write(string: "PING")
    
    pingQueue.asyncAfter(deadline: .now() + .seconds(Constants.pingInterval)) {[weak self] in
      self?.sendPing()
    }
  }
  
  /// Send message to Websocket
  ///
  /// - Parameters:
  ///   - subscriptionId: Unique subscription ID
  ///   - eventType: Qminder event type
  ///   - messageToSend: Message to send to Websocket
  ///   - callback: Callback block when response is received
  private func sendMessage(subscriptionId: String,
                           eventType: QminderWebsocketEvent,
                           messageToSend: String,
                           callback: Callback) {
    self.callbackMap[subscriptionId] = callback
    self.socket.write(string: messageToSend)
  }
}

extension QminderEvents: WebSocketDelegate {

  /// Delegate methods when websocket did connect
  ///
  /// - Parameter socket: Websocket object
  public func websocketDidConnect(socket: WebSocketClient) {
    log("Connection opened")

    openingConnection = false
    
    for message in messageHistory {
      socket.write(string: message)
    }
    
    //send message queue
    while messageQueue.count > 0 {
      let queueItem = messageQueue.removeFirst()

      sendMessage(subscriptionId: queueItem.subscriptionId,
                  eventType: queueItem.eventType,
                  messageToSend: queueItem.messageToSend,
                  callback: queueItem.callback)
      
      messageHistory.append(queueItem.messageToSend)
    }
    
    delegate?.onConnected()
    
    sendPing()
  }
  
  /// Delegate method when Websocket did disconnect
  ///
  /// - Parameters:
  ///   - socket: Websocket object
  ///   - error: Error why Websocket disconnected
  public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    log("Connection disconnected \(String(describing: error))")
    
    openingConnection = false
    
    delegate?.onDisconnected(error: error)
    
    reconnectQueue.asyncAfter(deadline: DispatchTime.now() + .seconds(Constants.reconnectInterval), execute: {
      self.reconnect(error: error)
    })
  }
  
  /// Delegate function when Websocket received message
  ///
  /// - Parameters:
  ///   - socket: Websocket object
  ///   - text: Received text
  public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    
    guard let data = text.data(using: .utf8) else { return }
    
    do {
      guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
        let subscriptionId = json["subscriptionId"] as? String,
        let callback = callbackMap[subscriptionId]
        else { return }
      
      parseWebSocketEvent(with: data, using: callback)
    } catch {
      log("Error deserializing JSON")
    }
  }
  
  /// Parse websocket event to Qminder event and execute callback
  ///
  /// - Parameters:
  ///   - data: Data to parse from
  ///   - callback: Callback map instance
  private func parseWebSocketEvent(with data: Data, using callback: Callback) {
    
    switch callback {
    case .ticket(let callback):
      guard let ticket = try? jsonDecoderWithMilliseconds.decode(TicketEventResponse.self, from: data).data else {
        return
      }
      
      callback(Result<Ticket, QminderError>.success(ticket))
    case .device(let callback):
      let device = try? jsonDecoderWithMilliseconds.decode(DeviceEventResponse.self, from: data).data
      
      callback(Result<TVDevice?, QminderError>.success(device))
    case .line(let callback):
      guard let lines = try? jsonDecoderWithMilliseconds.decode(LinesEventResponse.self, from: data).lines else {
        return
      }
      
      callback(Result<[Line], QminderError>.success(lines))
    }
  }

  /// Delegate function when Websocket received data
  ///
  /// - Parameters:
  ///   - socket: Websocket object
  ///   - data: Received data
  public func websocketDidReceiveData(socket: WebSocketClient, data: Data) { }
  
  /// Reconnect to Websocket
  ///
  /// - Parameter error: Error
  private func reconnect(error: Error?) {
    
    // If Websocket is closed normally or is connected already
    if connectionClosed || socket.isConnected {
      return
    }
    
    if let error = error as NSError? {
      // Don't reconect if going away normally
      if UInt16(error.code) == Constants.websocketReservedCloseCode {
        return
      }
    }
    
    openSocket()
    
    reconnectQueue.asyncAfter(deadline: DispatchTime.now() + .seconds(Constants.reconnectInterval), execute: {
      self.reconnect(error: error)
    })
  }
}
