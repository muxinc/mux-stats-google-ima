#!/bin/bash

readonly XCODE_VERSION=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

readonly SCHEME=DemoApp

readonly TOP_DIR=$(pwd)

readonly WORKSPACE_NAME=MUXSDKImaListener
readonly WORKSPACE_PATH=${TOP_DIR}/Example/${WORKSPACE_NAME}.xcworkspace

set -euo pipefail

brew install xcbeautify

echo "▸ Using Xcode Version: ${XCODE_VERSION}"

echo "▸ Resetting Simulators"

xcrun -v simctl shutdown all
xcrun -v simctl erase all

pushd Example

pod deintegrate && pod install

echo "▸ Executing Tests"

xcodebuild -workspace ${WORKSPACE_PATH} \
           -scheme "${SCHEME}" \
           -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.4' \
           test \
           | xcbeautify

popd

