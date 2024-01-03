#!/bin/bash
set -euo pipefail

if ! command -v xcbeautify &> /dev/null
then
  echo -e "\033[1;31m ERROR: xcbeautify could not be found please install it... \033[0m"
    exit 1
fi

echo "▸ Current Xcode: $(xcode-select -p)"

readonly XCODE=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

echo "▸ Using Xcode Version: ${XCODE}"

echo "▸ Available Xcode SDKs"
xcodebuild -showsdks

echo "▸ Running DemoApp tests"

xcodebuild clean test \
    -scheme DemoApp \
    -workspace Example/MUXSDKImaListener.xcworkspace \
    -destination 'platform=iOS Simulator,OS=17.2,name=iPhone 14' | xcbeautify

echo "▸ Running MUXSDKIMATVOSExample tests"

xcodebuild clean test \
    -scheme MUXSDKIMATVOSExample \
    -workspace Example/MUXSDKImaListener.xcworkspace \
    -destination 'platform=tvOS Simulator,OS=17.2,name=Apple TV' | xcbeautify
