// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MUXSDKStatsGoogleIMAPlugin",
    products: [
        .library(
            name: "MUXSDKStatsGoogleIMAPlugin", 
            targets: [
                "MUXSDKStatsGoogleIMAPlugin", 
                "GoogleInteractiveMediaAds",
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "MUXSDKStats",
            url: "https://github.com/muxinc/mux-stats-sdk-avplayer.git",
            from: "3.2.1"
        ),
    ],
    targets: [
        .target(
            name: "MUXSDKStatsGoogleIMAPlugin",
            dependencies: ["MUXSDKStats", "GoogleInteractiveMediaAds"],
            path: "MUXSDKImaListener/Classes"
        ),
        .binaryTarget(
            name: "GoogleInteractiveMediaAds",
            url: "https://imasdk.googleapis.com/native/downloads/ima-ios-v3.16.3.zip",
            checksum: "049bac92551b50247ea14dcbfde9aeb99ac2bea578a74f67c6f3e781d9aca101"
        )
    ]
)
