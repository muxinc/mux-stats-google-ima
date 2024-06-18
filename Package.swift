// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Mux_Stats_Google_IMA",
    products: [
        .library(
            name: "Mux_Stats_Google_IMA",
            targets: [
                "Mux_Stats_Google_IMA",
                "GoogleInteractiveMediaAds",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/muxinc/mux-stats-sdk-avplayer.git",
            from: "4.0.0"
        ),
    ],
    targets: [
        .target(
            name: "Mux_Stats_Google_IMA",
            dependencies: [
                .product(
                    name: "MUXSDKStats",
                    package: "mux-stats-sdk-avplayer"
                ),
                "GoogleInteractiveMediaAds"
            ],
            path: "MUXSDKImaListener/Classes"
        ),
        .binaryTarget(
              name: "GoogleInteractiveMediaAds",
              url: "https://imasdk.googleapis.com/downloads/ima/ios/GoogleInteractiveMediaAds-ios-v3.23.0.zip",
              checksum: "6fa5ad05c4ab85d74b8aad5fdace8a069f3dbd1eb820496bc04df7aeda0cd5e0"
        )
    ]
)
