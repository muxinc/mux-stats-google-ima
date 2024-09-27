#!/bin/bash

readonly XCODE_VERSION=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

readonly SCHEME=DemoApp

readonly TOP_DIR=$(pwd)

readonly WORKSPACE_NAME=MUXSDKImaListener
readonly WORKSPACE_PATH=${TOP_DIR}/Example/${WORKSPACE_NAME}.xcworkspace

set -euo pipefail

brew install xcbeautify

echo "▸ Switching to Xcode 15.4"
sudo xcode-select -s /Applications/Xcode_15.4.app

echo "▸ Using Xcode Version: ${XCODE_VERSION}"

echo "▸ Shutdown and reset the simulator"

xcrun -v simctl shutdown all
xcrun -v simctl erase all

pushd Example

echo "▸ Reinstalling Local Cocoapod"

pod deintegrate && pod install

echo "▸ Executing Tests"

xcodebuild -workspace ${WORKSPACE_PATH} \
           -scheme "${SCHEME}" \
           -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' \
           clean test \
           | xcbeautify

popd

