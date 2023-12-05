// swift-tools-version:5.3
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
            name: "MUXSDKStats",
            url: "https://github.com/muxinc/mux-stats-sdk-avplayer.git",
            from: "3.2.1"
        ),
    ],
    targets: [
        .target(
            name: "Mux_Stats_Google_IMA",
            dependencies: [
                "MUXSDKStats",
                .targetItem(
                    name: "GoogleInteractiveMediaAds",
                    condition: .when(platforms: [.iOS])
                ),
                .targetItem(
                    name: "GoogleInteractiveMediaAds_tvOS",
                    condition: .when(platforms: [.tvOS])
                )
            ],
            path: "MUXSDKImaListener/Classes"
        ),
        .binaryTarget(
            name: "GoogleInteractiveMediaAds",
            url: "https://imasdk.googleapis.com/native/downloads/ima-ios-v3.16.3.zip",
            checksum: "049bac92551b50247ea14dcbfde9aeb99ac2bea578a74f67c6f3e781d9aca101"
        ),
        .binaryTarget(
            name: "GoogleInteractiveMediaAds_tvOS",
            url: "https://imasdk.googleapis.com/native/downloads/ima-tvos-v4.9.2.zip",
            checksum: "c0c2c44a533bf36aafb871402612d0c067457e44bc7a24af62ccc38e285e7e98"
        )
    ]
)
