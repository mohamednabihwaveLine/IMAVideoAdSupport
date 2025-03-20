// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IMAVideoAdSupport",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "IMAVideoAdSupport",
            targets: ["IMAVideoAdSupport"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-interactive-media-ads-ios",
            exact: "3.24.0"
        )
    ],
    targets: [
        .target(
            name: "IMAVideoAdSupport",
            dependencies: [
                .product(name: "GoogleInteractiveMediaAds", package: "swift-package-manager-google-interactive-media-ads-ios")
            ]
        )
    ]
)
