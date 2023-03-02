// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "TestWebsockets",
    dependencies: [
        .package(url: "https://github.com/vapor/websocket.git", from: "1.1.2"),
        .package(url: "https://github.com/vapor/http.git", from: "3.4.0")
    ],
    targets: [
        .target(
            name: "TestWebsockets",
            dependencies: ["WebSocket", "HTTP"]),
    ]
)
