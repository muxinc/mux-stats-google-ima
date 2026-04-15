// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MuxStatsGoogleIMAPlugin",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
    ],
    products: [
        .library(
            name: "MuxStatsGoogleIMAPlugin",
            targets: [
                "MuxStatsGoogleIMAPlugin",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/muxinc/mux-stats-sdk-avplayer.git",
            from: "4.10.0"
        ),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-interactive-media-ads-ios",
            from: "3.30.0"
        ),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-interactive-media-ads-tvos",
            from: "4.16.0"
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
                .product(
                    name: "GoogleInteractiveMediaAds",
                    package: "swift-package-manager-google-interactive-media-ads-ios",
                    condition: .when(platforms: [.iOS])
                ),
                .product(
                    name: "GoogleInteractiveMediaAdsTvOS",
                    package: "swift-package-manager-google-interactive-media-ads-tvos",
                    condition: .when(platforms: [.tvOS])
                ),
            ]
        ),
        .testTarget(
            name: "MuxStatsGoogleIMAPluginTests",
            dependencies: [
                "MuxStatsGoogleIMAPlugin",
            ]
        ),
    ]
)
