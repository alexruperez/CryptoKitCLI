// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CryptoKitCLI",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "CryptoKitCLI",
            targets: ["CryptoKitCLI"]
        ),
        .library(
            name: "CryptoKitLib",
            targets: ["CryptoKitCLI"]
        ),
        .library(
            name: "CryptoKitLibDynamic",
            type: .dynamic,
            targets: ["CryptoKitCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser",
                 .upToNextMinor(from: "0.0.5")),
        .package(url: "https://github.com/kylef/PathKit",
                 .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/onevcat/Rainbow",
                 .upToNextMinor(from: "3.0.0"))
    ],
    targets: [
        .target(
            name: "CryptoKitCLI",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser"),
                .product(name: "PathKit",
                         package: "PathKit"),
                .product(name: "Rainbow",
                         package: "Rainbow")
            ]
        ),
        .testTarget(
            name: "CryptoKitCLITests",
            dependencies: ["CryptoKitCLI"]
        )
    ]
)
