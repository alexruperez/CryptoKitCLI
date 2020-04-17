// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CryptoKitCLI",
    products: [
        .executable(
            name: "CryptoKitCLI",
            targets: ["CryptoKitCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser",
                 .upToNextMinor(from: "0.0.4"))
    ],
    targets: [
        .target(
            name: "CryptoKitCLI",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "CryptoKitCLITests",
            dependencies: ["CryptoKitCLI"]
        )
    ]
)
