#!/bin/bash

readonly XCODE_VERSION=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

readonly SCHEME=MuxStatsGoogleIMAPlugin

readonly TOP_DIR=$(pwd)

set -euo pipefail

brew install xcbeautify

echo "▸ Using Xcode Version: ${XCODE_VERSION}"

echo "▸ Executing Tests"

xcodebuild -scheme "${SCHEME}" \
           -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
           clean test \
           | xcbeautify

xcodebuild -scheme "${SCHEME}" \
           -destination 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation) (at 1080p)' \
           clean test \
           | xcbeautify
