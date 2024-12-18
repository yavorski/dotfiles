#!/usr/bin/env bash

# Downloads latest version of rzls.linux-x64 and install it in ~/.local/share/nvim/rzls/
# https://dev.azure.com/azure-public/vside/_artifacts/feed/msft_consumption/NuGet/rzls.linux-x64/overview/

# exit on error
set -euo pipefail

# Package details
ORG="azure-public"
PROJECT="vside"
FEED="msft_consumption"
PACKAGE_NAME="rzls.linux-x64"

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
NVIM_RZLS_DIR="$HOME/.local/share/nvim/rzls"
rm -rf "$NVIM_RZLS_DIR"
mv "$UNZIP_DIR/content/LanguageServer/linux-x64" "$NVIM_RZLS_DIR"

# Delete left over files
rm -f "$NUPKG"
rm -rf "$UNZIP_DIR"

# Ok
echo "Successfully updated RZLS"
