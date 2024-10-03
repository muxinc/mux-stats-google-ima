// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MuxStatsGoogleIMAPlugin",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "MuxStatsGoogleIMAPlugin",
            targets: [
                "MuxStatsGoogleIMAPlugin",
                "GoogleInteractiveMediaAds",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/muxinc/mux-stats-sdk-avplayer.git",
            from: "4.1.0"
        ),
    ],
    targets: [
        .target(
            name: "MuxStatsGoogleIMAPlugin",
            dependencies: [
                .product(
                    name: "MUXSDKStats",
                    package: "mux-stats-sdk-avplayer"
                ),
                "GoogleInteractiveMediaAds"
            ]
        ),
        .binaryTarget(
              name: "GoogleInteractiveMediaAds",
              url: "https://imasdk.googleapis.com/downloads/ima/ios/GoogleInteractiveMediaAds-ios-v3.23.0.zip",
              checksum: "6fa5ad05c4ab85d74b8aad5fdace8a069f3dbd1eb820496bc04df7aeda0cd5e0"
        ),
        .testTarget(
            name: "MuxStatsGoogleIMAPluginTests",
            dependencies: [
                "MuxStatsGoogleIMAPlugin",
                "GoogleInteractiveMediaAds"
            ]
        ),
    ]
)
