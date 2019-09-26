[![CI Status](https://img.shields.io/travis/muxinc/mux-stats-google-ima.svg?style=flat)](https://travis-ci.org/muxinc/mux-stats-google-ima)
[![Version](https://img.shields.io/cocoapods/v/Mux-Stats-Google-IMA.svg?style=flat)](https://cocoapods.org/pods/Mux-Stats-Google-IMA)
[![License](https://img.shields.io/cocoapods/l/Mux-Stats-Google-IMA.svg?style=flat)](https://cocoapods.org/pods/Mux-Stats-Google-IMA)
[![Platform](https://img.shields.io/cocoapods/p/Mux-Stats-Google-IMA.svg?style=flat)](https://cocoapods.org/pods/Mux-Stats-Google-IMA)

# Mux-Stats-Google-IMA

This pod was created with `pod lib create`

## Development

To run the example project, clone the repo, and run `pod install` from the Example directory first. Then open
up the .workspace in the Example/ directory

## Tests

Run tests in XCode with cmd + u


## Installation

MUXSDKImaListener is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mux-Stats-Google-IMA'
```

## Releasing a new version

* Update Mux-Stats-Google-IMA.podspec
* cd Example/ and run `pod install` (this will install the updated version into the example app)
* run `carthage build --no-skip-current` (brew install carthage if you haven't already)
* run `carthage archive Mux_Stats_Google_IMA` - this will build a .zip folder
* commit your changes
* git tag vX.X.X (example: git tag v0.3.0)
* git push --tags
* attach the .zip folder to the Release in github
* pod trunk push Mux-Stats-Google-IMA.podspec --allow-warnings

## Author

Mux, ios-sdk@mux.com

