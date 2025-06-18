[![Version](https://img.shields.io/cocoapods/v/Mux-Stats-Google-IMA.svg?style=flat)](https://cocoapods.org/pods/Mux-Stats-Google-IMA)
[![License](https://img.shields.io/cocoapods/l/Mux-Stats-Google-IMA.svg?style=flat)](https://cocoapods.org/pods/Mux-Stats-Google-IMA)
[![Platform](https://img.shields.io/cocoapods/p/Mux-Stats-Google-IMA.svg?style=flat)](https://cocoapods.org/pods/Mux-Stats-Google-IMA)

# Mux-Stats-Google-IMA

## Development

To run the example project, clone the repo, and run `pod install` from the Example directory first. Then open
up the .workspace in the Example/ directory

## Tests

Run tests in XCode with cmd + u

## Installation

### Swift Package Manager

In order to install in your iOS application open your `Package.swift` file, add the following to `dependencies`.

```swift
.package(
	url: "https://github.com/muxinc/mux-stats-google-ima",
	.upToNextMajor(from: "0.15.0")
 ),
```

Swift Package Manager does not support installation of Google IMA packages for both iOS `GoogleAds-IMA-iOS-SDK` and tvOS `GoogleAds-IMA-tvOS-SDK` at the same time because they cannot be disambiguated at the time of package resolution. [This is a known issue with Google IMA tracked here](https://github.com/googleads/swift-package-manager-google-interactive-media-ads-tvos/issues/1).

As a workaround, if installing for just tvOS, add the following binary target to your `Package.swift` file.

```swift
.binaryTarget(
    name: "MuxStatsGoogleIMAPluginTVOS",
    url: "https://github.com/muxinc/mux-stats-google-ima/releases/download/v0.14.0/MuxStatsGoogleIMAPluginTVOS.xcframework.zip",
    checksum: "c0a0499a471a20803e29e3133d51a45ed81d53152e6a19e9e7e4f611662505ce"
)
```

### Cocoapods

The Mux Google IMA plugin is available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your Podfile:

```ruby
pod 'Mux-Stats-Google-IMA'
```

### Manual Installation

* Depending on the platforms your application is targeting, download and integrate `GoogleAds-IMA-iOS-SDK` or `GoogleAds-IMA-tvOS-SDK`.
* Navigate to the most recent release listed [here](https://github.com/muxinc/mux-stats-google-ima/releases).
* For iOS applications download `MuxStatsGoogleIMAPlugin.xcframework.zip`
* For tvOS applications download `MuxStatsGoogleIMAPluginTVOS.xcframework.zip`
* Unzip the xcframework and add to your Xcode project

## Releasing a new version

1. Checkout a new release branch named releases/vX.Y.Z where X, Y, and Z are the major, minor, and patch versions of the released SDK.
2. Update Mux-Stats-Google-IMA.podspec with new major, minor, and patch versions.
3. Update marketing version with new major, minor, and patch versions in Xcode project files in `FrameworkProject/MuxStatsGoogleIMAPlugin` and `FrameworkProject/MuxStatsGoogleIMAPluginTVOS`   
4. create a PR against master for your `releaes/v*` branch
5. merge PR after release notes pop in (check them for spelling/grammar/tone)
6. wait for PR comment to appear with a link to a draft release
7. attach the `MuxStatsGoogleIMAPlugin.xcframework.zip` anc `MuxStatsGoogleIMAPluginTVOS.xcframework.zip` file to that release
8. Create the release
9. From up-to-date `master`: `pod trunk push Mux-Stats-Google-IMA.podspec --allow-warnings`
