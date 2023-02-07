#!/bin/bash
set -euo pipefail

brew install xcbeautify

# reset simulators
xcrun -v simctl shutdown all
xcrun -v simctl erase all

echo "test xcode version"
xcodebuild -version

pushd Example
#pod deintegrate && pod update

xcodebuild -workspace MUXSDKImaListener.xcworkspace \
           -scheme "MUXSDKImaListener-Example" \
           -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' \
           test \
           | xcbeautify
xcrun -v simctl shutdown all # The simulator seems to crash without this
xcodebuild -workspace MUXSDKImaListener.xcworkspace \
           -scheme "DemoApp" \
           -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' \
           test \
           | xcbeautify

popd

