#!/usr/bin/env bash

# Downloads latest version of Microsoft.CodeAnalysis.LanguageServer and installs it
# Linux: ~/.local/share/nvim/roslyn/
# Windows (via --windows flag): /mnt/c/dev/roslyn/
# https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.linux-x64/overview/

# exit on error
set -euo pipefail

# Parse arguments
IS_WINDOWS=false
if [ "${1:-}" = "--windows" ]; then
  IS_WINDOWS=true
fi

# Package details
ORG="azure-public"
PROJECT="vside"
FEED="vs-impl"

# Set platform-specific variables
if [ "$IS_WINDOWS" = true ]; then
  PACKAGE_NAME="Microsoft.CodeAnalysis.LanguageServer.win-x64"
  PLATFORM="win-x64"
  INSTALL_DIR="/mnt/c/dev/roslyn"
else
  PACKAGE_NAME="Microsoft.CodeAnalysis.LanguageServer.linux-x64"
  PLATFORM="linux-x64"
  INSTALL_DIR="$HOME/.local/share/nvim/roslyn"
fi

# API URL to get package versions
API_URL="https://feeds.dev.azure.com/$ORG/$PROJECT/_apis/packaging/Feeds/$FEED/packages?packageNameQuery=$PACKAGE_NAME&api-version=7.1"
echo "API_URL: $API_URL"

# Fetch the latest version
API_RESPONSE=$(curl --silent --fail "$API_URL")
LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.value[0].versions | sort_by(.normalizedVersion) | last.normalizedVersion')

# Ensure version was retrieved
if [ -z "$LATEST_VERSION" ]; then
  echo "Error: Could not retrieve latest version"
  exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Construct download URL
DOWNLOAD_URL="https://pkgs.dev.azure.com/$ORG/$PROJECT/_apis/packaging/feeds/$FEED/nuget/packages/$PACKAGE_NAME/versions/$LATEST_VERSION/content"
echo "Download URL: $DOWNLOAD_URL"

# Download package
NUPKG="$PACKAGE_NAME.$LATEST_VERSION.nupkg"
rm -f "$NUPKG"

curl --fail --location --output "$NUPKG" "$DOWNLOAD_URL"
echo "Downloaded: $NUPKG"

# Ensure unzip is available
if ! command -v unzip >/dev/null 2>&1; then
  echo "Error: 'unzip' not found. Install it first."
  exit 1
fi

# Unzip package
UNZIP_DIR="$PACKAGE_NAME"
rm -rf "$UNZIP_DIR"
unzip -q "$NUPKG" -d "$UNZIP_DIR"

# Move to correct location
rm -rf "$INSTALL_DIR"
mv "$UNZIP_DIR/content/LanguageServer/$PLATFORM" "$INSTALL_DIR"

# Delete left over files
rm -f "$NUPKG"
rm -rf "$UNZIP_DIR"

# Ok
echo "Successfully updated Roslyn for $PLATFORM"
