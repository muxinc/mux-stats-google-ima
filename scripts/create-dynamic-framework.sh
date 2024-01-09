#!/bin/bash
set -euo pipefail

echo "▸ Selecting Xcode 15.1"
# sudo xcode-select -s /Applications/Xcode_15.1.app

echo "▸ Installing xcbeautify"
brew install xcbeautify

if ! command -v xcbeautify &> /dev/null
then
  echo -e "\033[1;31m ERROR: xcbeautify could not be found please install it... \033[0m"
    exit 1
fi

readonly BUILD_DIR=$PWD/.build
readonly WORKSPACE=$PWD/CarthageScheme/MUXSDKStatsGoogleIMAPlugin/MUXSDKStatsGoogleIMAPlugin.xcworkspace
readonly PROJECT=$PWD/CarthageScheme/MUXSDKStatsGoogleIMAPlugin/MUXSDKStatsGoogleIMAPlugin.xcodeproj
readonly TARGET_DIR=$PWD/XCFramework

readonly IOS_SCHEME="MUXSDKStatsGoogleIMAPlugin"
readonly TVOS_SCHEME="MUXSDKStatsGoogleIMAPluginTVOS"

readonly FRAMEWORK_NAME="MUXSDKStatsGoogleIMAPlugin"
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

echo "▸ Creating tvOS archive"

xcodebuild clean archive \
    -scheme $TVOS_SCHEME \
    -workspace $WORKSPACE \
    -destination "generic/platform=tvOS" \
    -archivePath "$BUILD_DIR/MUXSDKStatsGoogleIMAPluginTVOS.tvOS.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify

echo "▸ Creating tvOS Simulator archive"

xcodebuild clean archive \
    -scheme $TVOS_SCHEME \
    -workspace $WORKSPACE \
    -destination "generic/platform=tvOS Simulator" \
    -archivePath "$BUILD_DIR/MUXSDKStatsGoogleIMAPluginTVOS.tvOS-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify

echo "▸ Creating iOS archive"

xcodebuild clean archive \
    -scheme $IOS_SCHEME \
    -workspace $WORKSPACE \
    -destination "generic/platform=iOS" \
    -archivePath "$BUILD_DIR/MUXSDKStatsGoogleIMAPlugin.iOS.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify

echo "▸ Creating iOS Simulator archive"

xcodebuild clean archive \
    -scheme $IOS_SCHEME \
    -workspace $WORKSPACE \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$BUILD_DIR/MUXSDKStatsGoogleIMAPlugin.iOS-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify

xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/MUXSDKStatsGoogleIMAPluginTVOS.tvOS.xcarchive/Products/Library/Frameworks/MUXSDKStatsGoogleIMAPlugin.framework" \
    -framework "$BUILD_DIR/MUXSDKStatsGoogleIMAPluginTVOS.tvOS-simulator.xcarchive/Products/Library/Frameworks/MUXSDKStatsGoogleIMAPlugin.framework" \
    -framework "$BUILD_DIR/MUXSDKStatsGoogleIMAPlugin.iOS.xcarchive/Products/Library/Frameworks/MUXSDKStatsGoogleIMAPlugin.framework" \
    -framework "$BUILD_DIR/MUXSDKStatsGoogleIMAPlugin.iOS-simulator.xcarchive/Products/Library/Frameworks/MUXSDKStatsGoogleIMAPlugin.framework" \
    -output "${TARGET_DIR}/${PACKAGE_NAME}" | xcbeautify

if [[ $? == 0 ]]; then
    echo "▸ Successfully created ${FRAMEWORK_NAME} XCFramework at ${TARGET_DIR}"
else
    echo -e "\033[1;31m ERROR: Failed to create ${FRAMEWORK_NAME} XCFramework \033[0m"
    exit 1
fi

echo "▸ Deleting Build Directory: ${BUILD_DIR}"

# rm -Rf $BUILD_DIR
