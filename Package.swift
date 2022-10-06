// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MUXSDKImaListener",
    products: [
        .library(name: "Mux_Stats_Google_IMA", targets: ["MUXSDKImaListener"]),
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
            name: "MUXSDKImaListener",
            dependencies: ["MUXSDKStats"],
            path: "MUXSDKImaListener/Classes"
        ),
    ]
)
