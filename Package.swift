// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Mux_Stats_Google_IMA",
    products: [
        .library(name: "Mux_Stats_Google_IMA", targets: ["Mux_Stats_Google_IMA", "GoogleInteractiveMediaAds",]),
    ],
    dependencies: [
        .package(
            name: "MUXSDKStats",
            url: "https://github.com/muxinc/mux-stats-sdk-avplayer.git",
            from: "2.13.0"
        ),
    ],
    targets: [
        .target(
            name: "Mux_Stats_Google_IMA",
            dependencies: ["MUXSDKStats"],
            path: "MUXSDKImaListener/Classes"
        ),
        .binaryTarget(
            name: "GoogleInteractiveMediaAds",
            url: "https://imasdk.googleapis.com/native/downloads/ima-ios-v3.16.3.zip",
            checksum: "049bac92551b50247ea14dcbfde9aeb99ac2bea578a74f67c6f3e781d9aca101"
        )
    ]
)
