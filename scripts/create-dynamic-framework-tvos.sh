#!/bin/bash
set -euo pipefail

echo "▸ Selected Xcode Path: $(xcode-select -p)"

if ! command -v xcbeautify &> /dev/null
then
  echo -e "\033[1;31m ERROR: xcbeautify could not be found please install it... \033[0m"
    exit 1
fi

readonly BUILD_DIR=$PWD/.build
readonly PROJECT=$PWD/FrameworkProject/MUXStatsGoogleIMAPluginTVOS/MUXStatsGoogleIMAPluginTVOS.xcodeproj
readonly TARGET_DIR=$PWD/XCFramework

readonly TVOS_SCHEME="MuxStatsGoogleIMAPluginTVOS"

readonly FRAMEWORK_NAME="MuxStatsGoogleIMAPluginTVOS"
readonly PACKAGE_NAME=${FRAMEWORK_NAME}.xcframework

echo "▸ Current Xcode: $(xcode-select -p)"

readonly XCODE=$(xcodebuild -version | grep Xcode | cut -d " " -f2)

echo "▸ Using Xcode Version: ${XCODE}"

echo "▸ Available Xcode SDKs"
xcodebuild -showsdks

echo "▸ Deleting Target Directory: ${TARGET_DIR}"
rm -Rf $TARGET_DIR

echo "▸ Creating Build Directory: ${BUILD_DIR}"
mkdir -p $BUILD_DIR

echo "▸ Creating Target Directory: ${TARGET_DIR}"
mkdir -p $TARGET_DIR

echo "▸ Available Schemes: $(xcodebuild -list -project FrameworkProject/MuxStatsGoogleIMAPlugin/MuxStatsGoogleIMAPlugin.xcodeproj)"

echo "▸ Creating tvOS archive"

xcodebuild clean archive \
    -scheme $TVOS_SCHEME \
    -project $PROJECT \
    -destination "generic/platform=tvOS" \
    -archivePath "$BUILD_DIR/MuxStatsGoogleIMAPluginTVOS.tvOS.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify

echo "▸ Creating tvOS Simulator archive"

xcodebuild clean archive \
    -scheme $TVOS_SCHEME \
    -project $PROJECT \
    -destination "generic/platform=tvOS Simulator" \
    -archivePath "$BUILD_DIR/MuxStatsGoogleIMAPluginTVOS.tvOS-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify

xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/MuxStatsGoogleIMAPluginTVOS.tvOS.xcarchive/Products/Library/Frameworks/MuxStatsGoogleIMAPluginTVOS.framework" \
    -framework "$BUILD_DIR/MuxStatsGoogleIMAPluginTVOS.tvOS-simulator.xcarchive/Products/Library/Frameworks/MuxStatsGoogleIMAPluginTVOS.framework" \
    -output "${TARGET_DIR}/${PACKAGE_NAME}" | xcbeautify

if [[ $? == 0 ]]; then
    echo "▸ Successfully created ${FRAMEWORK_NAME} XCFramework at ${TARGET_DIR}"
else
    echo -e "\033[1;31m ERROR: Failed to create ${FRAMEWORK_NAME} XCFramework \033[0m"
    exit 1
fi

echo "▸ Deleting Build Directory: ${BUILD_DIR}"

rm -Rf $BUILD_DIR
