// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Mux_Stats_Google_IMA",
    products: [
        .library(name: "Mux_Stats_Google_IMA", targets: ["Mux_Stats_Google_IMA"]),
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
    ]
)
