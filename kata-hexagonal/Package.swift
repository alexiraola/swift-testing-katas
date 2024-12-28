// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KataHexagonal",
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-testing.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0"..<"4.0.0"),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "KataHexagonal",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            path: "Sources",
            swiftSettings: swiftSettings),
        .testTarget(
            name: "KataHexagonalTests",
            dependencies: [
                "KataHexagonal",
                .product(name: "Testing", package: "swift-testing"),
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableExperimentalFeature("StrictConcurrency"),
    ]
}
