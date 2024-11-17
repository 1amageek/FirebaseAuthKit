// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseAuthKit",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(name: "FirebaseAuthKit", targets: ["FirebaseAuthKit"]),
        .library(name: "FirebaseAuthVapor", targets: ["FirebaseAuthVapor"]),
//        .library(name: "FirebaseAuthHummingbird", targets: ["FirebaseAuthHummingbird"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.1.1"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.106.3"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.4.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.23.1"),
    ],
    targets: [
        // Core functionality
        .target(
            name: "FirebaseAuthKit",
            dependencies: [
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]
        ),
        // Vapor integration
        .target(
            name: "FirebaseAuthVapor",
            dependencies: [
                "FirebaseAuthKit",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        // Hummingbird integration
        .target(
            name: "FirebaseAuthHummingbird",
            dependencies: [
                "FirebaseAuthKit",
                .product(name: "Hummingbird", package: "hummingbird")
            ]
        ),
        .testTarget(
            name: "FirebaseAuthKitTests",
            dependencies: ["FirebaseAuthKit"]),
    ]
)
