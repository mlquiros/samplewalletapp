// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wallet",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Wallet",
            targets: ["Wallet"]
        ),
    ],
    dependencies: [
//      .package(name: "CoreWebAPI", path: "../Packages/CoreWebAPI")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Wallet",
//            dependencies: [.product(name: "CoreWebAPI", package: "CoreWebAPI")]
        ),
        .testTarget(
            name: "WalletTests",
            dependencies: ["Wallet"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
