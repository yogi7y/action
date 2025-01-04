#!/bin/bash

# Print commands before executing and exit on any error
set -xe

# Function to display an error message and exit
error_exit() {
    echo "Error: $1"
    exit 1
}

# Check if flavor parameter is provided, default to production
FLAVOR=${1:-production}

# Check if build mode is provided, default to release
BUILD_MODE=${2:-release}

# Clean build directory to ensure fresh build
echo "🧹 Cleaning build directory..."
fvm flutter clean || error_exit "Failed to clean build directory"

# Get dependencies
echo "📦 Getting dependencies..."
fvm flutter pub get || error_exit "Failed to get dependencies"

# Build the APK
echo "🏗️  Building $FLAVOR flavor in $BUILD_MODE mode..."
fvm flutter build apk \
    --$BUILD_MODE \
    --flavor $FLAVOR \
    --target lib/main_$FLAVOR.dart || error_exit "Failed to build APK"

# Define APK path based on build mode
APK_PATH="build/app/outputs/flutter-apk/app-$FLAVOR-$BUILD_MODE.apk"

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    error_exit "APK not found at $APK_PATH"
fi

# Install APK on connected device
echo "📱 Installing APK..."
adb install "$APK_PATH" || error_exit "Failed to install APK"

echo "✅ Build and installation completed successfully!"