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
           -scheme "DemoApp" \
           -destination 'platform=iOS Simulator,name=iPhone 13,OS=16.0' \
           test \
           | xcbeautify

popd

