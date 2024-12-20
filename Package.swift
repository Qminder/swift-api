// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "QminderAPI",
    products: [
        .library(
            name: "QminderAPI",
            targets: ["QminderAPI"])
    ],
    targets: [
        .target(
            name: "QminderAPI",
            path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
