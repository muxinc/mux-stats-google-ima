#!/bin/bash

readonly XCODE_VERSION=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

readonly SCHEME=MuxStatsGoogleIMAPlugin

readonly TOP_DIR=$(pwd)

set -euo pipefail

brew install xcbeautify

echo "▸ Using Xcode Version: ${XCODE_VERSION}"

echo "▸ Executing Tests"

xcodebuild -scheme "${SCHEME}" \
           -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' \
           clean test \
           | xcbeautify
