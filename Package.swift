// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "QminderAPI",
    products: [
        .library(
            name: "QminderAPI",
            targets: ["QminderAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.1.0")
    ],
    targets: [
        .target(
            name: "QminderAPI",
            dependencies: ["Starscream"],
            path: "Sources")
    ]
)
