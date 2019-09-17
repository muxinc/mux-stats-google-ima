# MUXSDKImaListener

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

## Author

Mux, ios-sdk@mux.com

