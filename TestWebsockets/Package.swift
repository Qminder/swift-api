// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "TestWebsockets",
    dependencies: [
        .package(url: "https://github.com/vapor/websocket.git", from: "2.15.0"),
        .package(url: "https://github.com/vapor/http.git", from: "3.4.0")
    ],
    targets: [
        .target(
            name: "TestWebsockets",
            dependencies: ["WebSocket", "HTTP"]),
    ]
)
