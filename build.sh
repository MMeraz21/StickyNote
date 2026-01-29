#!/bin/bash

set -e

APP_NAME="StickyNote"
BUNDLE_ID="com.local.StickyNote"
VERSION="1.0"

echo "🔨 Building $APP_NAME..."

# Build release version
swift build -c release

echo "📦 Creating app bundle..."

# Clean previous build
rm -rf "$APP_NAME.app"

# Create app bundle structure
mkdir -p "$APP_NAME.app/Contents/MacOS"
mkdir -p "$APP_NAME.app/Contents/Resources"

# Copy the executable
cp ".build/release/$APP_NAME" "$APP_NAME.app/Contents/MacOS/"

# Create Info.plist
cat > "$APP_NAME.app/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>Sticky Note</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ Build complete!"
echo ""
echo "📍 App bundle created at: $APP_NAME.app"
echo ""
echo "To install:"
echo "  cp -r $APP_NAME.app /Applications/"
echo ""
echo "To run:"
echo "  open $APP_NAME.app"
echo ""
echo "To add to Login Items (start at boot):"
echo "  1. Open System Settings → General → Login Items"
echo "  2. Click '+' and select $APP_NAME.app from Applications"

