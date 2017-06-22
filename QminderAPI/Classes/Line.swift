//
//  Line.swift
//  Pods
//
//  Created by Kristaps Grinbergs on 16/12/2016.
//
//

import Foundation

import ObjectMapper


/// Line Object
public struct Line: Mappable {
  
  /// ID of a line
  public var id: Int?
  
  /// Name of a line
  public var name: String?
  
  /// ID of the location this line belongs to
  public var location: Int?
  
  public init?(map: Map) {}
  
  public mutating func mapping(map: Map) {
    id <- (map["id"], StringOrIntToInt())
    name <- map["name"]
    location <- (map["location"], StringOrIntToInt())
  }
}


/// Lines object
struct Lines: Mappable {

  /// Lines array
  var lines: Array<Line>?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    lines <- map["data"]
  }
}
