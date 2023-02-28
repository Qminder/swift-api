//: Playground - noun: a place where people can play


import QminderAPI
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Load API key from file
// Put your API key in apiKey.txt
var apiKey: String = ""
do {
  let url = Bundle.main.url(forResource: "apiKey", withExtension: "txt")
  apiKey = try String.init(contentsOf: url!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
} catch {
  print("Can't set API key")
}

let qminderAPI = QminderAPI(apiKey: apiKey)

qminderAPI.getLocationsList {
  let _ = prettyPrint("Locations list", $0)
}

qminderAPI.getLocationLines(locationId: 9135) {
  let _ = prettyPrint("Location lines", $0)
}

qminderAPI.getLocationDesks(locationId: 9135) {
  let _ = prettyPrint("Location desks", $0)
}

qminderAPI.getLineDetails(lineId: 64612) {
  let _ = prettyPrint("Line details", $0)
}

qminderAPI.getTicketDetails(ticketId: "35604156") {
  let _ = prettyPrint("Ticket details", $0)
}

qminderAPI.getUserDetails(userId: 891) {
  let _ = prettyPrint("User details", $0)
}

qminderAPI.getPairingCodeAndSecret {
  let _ = prettyPrint("Pairing code", $0)
}

qminderAPI.pairTV(code: "XXX", secret: "YYY") {
  let _ = prettyPrint("Pairing status", $0)
}

qminderAPI.tvDetails(id: 11389) {
  let _ = prettyPrint("TV details", $0)
}

qminderAPI.tvEmptyState(id: 11389, language: "en") {
  let _ = prettyPrint("TV empty state", $0)
}

qminderAPI.tvHeartbeat(id: 11389, metadata: ["test": "test"]) {
  print("TV heartbeat")
  print($0)
}
