[![CI Status](https://img.shields.io/travis/muxinc/mux-stats-google-ima.svg?style=flat)](https://github.com/muxinc/mux-stats-google-ima/actions/workflows/build-and-test/badge.svg)
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

MUXSDKImaListener is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mux-Stats-Google-IMA'
```

## Releasing a new version
#### From a branch called releases/v[new version number]

* Update Mux-Stats-Google-IMA.podspec
* cd Example/ and run `pod install` (this will install the updated version into the example app)
* run `carthage build --no-skip-current --use-xcframeworks` (brew install carthage if you haven't already)
* run `carthage archive Mux_Stats_Google_IMA` - this will build a .zip folder
* commit your changes & push to remote
* create a PR against master for your `releaes/v*` branch
* merge PR after release notes pop in (check them for spelling/grammar/tone)
* wait for PR comment to appear with a link to a draft release
* attach the `Mux_Stats_Google_IMA.framework.zip` file to that release
* Create the release
* from Updated `master`: `pod trunk push Mux-Stats-Google-IMA.podspec --allow-warnings`

## Author

Mux, ios-sdk@mux.com

