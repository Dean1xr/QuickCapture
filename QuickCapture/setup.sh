#!/bin/bash
set -e

echo "============================================"
echo "  QuickCapture – Xcode Project Generator"
echo "============================================"
echo ""

# Check for Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check for xcodegen
if ! command -v xcodegen &>/dev/null; then
  echo "Installing xcodegen..."
  brew install xcodegen
fi

# Move into project directory (same dir as this script)
cd "$(dirname "$0")"

echo ""
echo "Generating Xcode project..."
xcodegen generate

echo ""
echo "============================================"
echo "  Done! Open QuickCapture.xcodeproj in Xcode"
echo "============================================"
open QuickCapture.xcodeproj
