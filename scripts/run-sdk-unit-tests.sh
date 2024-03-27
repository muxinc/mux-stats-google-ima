#!/bin/bash

readonly XCODE_VERSION=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

readonly SCHEME=DemoApp

readonly TOP_DIR=$(pwd)

readonly WORKSPACE_NAME=MUXSDKImaListener
readonly WORKSPACE_PATH=${TOP_DIR}/Example/${WORKSPACE_NAME}.xcworkspace

set -euo pipefail

echo "▸ Selecting Xcode 15.1"
sudo xcode-select -s /Applications/Xcode_15.1.app

echo "▸ Installing xcbeautify"
brew install xcbeautify

if ! command -v xcbeautify &> /dev/null
then
  echo -e "\033[1;31m ERROR: xcbeautify could not be found please install it... \033[0m"
    exit 1
fi

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
           -destination 'platform=iOS Simulator,name=iPhone 14,OS=17.2' \
           clean test \
           | xcbeautify

popd

