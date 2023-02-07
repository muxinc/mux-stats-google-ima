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
#xcrun -v simctl shutdown all # The simulator seems to crash without this

# https://circleci.com/blog/xcodebuild-exit-code-65-what-it-is-and-how-to-solve-for-ios-and-macos-builds/
# xcrun instruments -w 'iPhone 14 (16.2)' || sleep 15

#xcrun -v simctl shutdown all
#xcrun -v simctl erase all

xcodebuild -workspace MUXSDKImaListener.xcworkspace \
           -scheme "DemoApp" \
           -destination 'platform=iOS Simulator,name=iPhone 15,OS=16.2' \
           test \
           #| xcbeautify

popd

