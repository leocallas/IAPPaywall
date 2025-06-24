// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IAPPaywall",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "IAPPaywall",
            targets: ["IAPPaywall"]),
    ],
    targets: [
        .target(
            name: "IAPPaywall"
        ),
        .testTarget(
            name: "IAPPaywallTests",
            dependencies: ["IAPPaywall"]),
    ]
)
