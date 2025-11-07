// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WalletSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "WalletSDK",
            targets: ["WalletSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/argentlabs/web3.swift", from: "1.6.0"),
        .package(url: "https://github.com/attaswift/BigInt", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "WalletSDK",
            dependencies: [
                .product(name: "Web3", package: "web3.swift"),
                "BigInt"
            ]
        ),
        .testTarget(
            name: "WalletSDKTests",
            dependencies: ["WalletSDK"]
        ),
    ]
)
