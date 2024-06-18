#!/bin/bash

readonly XCODE_VERSION=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

readonly SCHEME=DemoApp

readonly TOP_DIR=$(pwd)

readonly WORKSPACE_NAME=MUXSDKImaListener
readonly WORKSPACE_PATH=${TOP_DIR}/Example/${WORKSPACE_NAME}.xcworkspace

set -euo pipefail

brew install xcbeautify

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
           -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
           clean test \
           | xcbeautify

popd

