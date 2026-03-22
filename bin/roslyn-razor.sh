#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Platform flag (defaults to linux, can be overridden via command line)
PLATFORM="linux"

# Configuration
CSHARP_VERSION="${CSHARP_VERSION:-latest}"
CSDEVKIT_VERSION="${CSDEVKIT_VERSION:-latest}"

# Extension IDs
CSHARP_EXT="ms-dotnettools.csharp"
CSDEVKIT_EXT="ms-dotnettools.csdevkit"

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1" >&2
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_usage() {
  echo "Usage: $0 [--linux|--mac|--windows] [OPTIONS]"
  echo ""
  echo "Platform flags (optional, defaults to linux):"
  echo "  --linux                 Install for Linux x64/ARM64 (default)"
  echo "  --mac                   Install for macOS x64/ARM64"
  echo "  --windows               Install for Windows x64"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show this help message"
  echo ""
  echo "Environment variables:"
  echo "  INSTALL_DIR             Installation directory"
  echo "                          (default: ~/dev/roslyn-razor for Linux/macOS)"
  echo "                          (default: /mnt/c/dev/roslyn-razor for Windows)"
  echo "  CSHARP_VERSION          C# extension version (default: latest)"
  echo "  CSDEVKIT_VERSION        C# Dev Kit version (default: latest)"
  echo ""
  echo "Example:"
  echo "  $0                      # Defaults to --linux"
  echo "  $0 --linux"
  echo "  INSTALL_DIR=/opt/roslyn-razor $0 --mac"
  echo "  CSHARP_VERSION=2.131.79 $0 --windows"
  exit 0
}

get_platform_string() {
  local platform_flag=$1
  local arch=$(uname -m)

  case "$platform_flag" in
    linux)
      case "$arch" in
        x86_64) echo "linux-x64" ;;
        aarch64|arm64) echo "linux-arm64" ;;
        *) log_error "Unsupported architecture: $arch"; exit 1 ;;
      esac
      ;;
    mac)
      case "$arch" in
        x86_64) echo "darwin-x64" ;;
        arm64) echo "darwin-arm64" ;;
        *) log_error "Unsupported architecture: $arch"; exit 1 ;;
      esac
      ;;
    windows)
      echo "win32-x64"
      ;;
    *)
      log_error "Invalid platform: $platform_flag"
      exit 1
      ;;
  esac
}

get_default_install_dir() {
  local platform_flag=$1

  if [ "$platform_flag" = "windows" ]; then
    echo "/mnt/c/dev/roslyn-razor"
  else
    echo "$HOME/dev/roslyn-razor"
  fi
}

get_latest_version() {
  local extension_id=$1
  local url="https://marketplace.visualstudio.com/items?itemName=$extension_id"

  log_info "Fetching latest version for $extension_id..."

  # Try to get version from marketplace page
  local version=$(curl -sL "$url" | grep -oP '"version":"[^"]+' | head -1 | cut -d'"' -f4)

  if [ -z "$version" ]; then
    log_error "Failed to fetch latest version for $extension_id"
    exit 1
  fi

  echo "$version"
}

download_vsix() {
  local extension_id=$1
  local version=$2
  local platform=$3
  local output=$4

  local publisher=$(echo "$extension_id" | cut -d'.' -f1)
  local name=$(echo "$extension_id" | cut -d'.' -f2)

  # Try platform-specific version first
  local url="https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=${platform}"

  log_info "Downloading $extension_id v$version for $platform..."
  log_info "URL: $url"

  if ! curl -L -f -o "$output" "$url" 2>/dev/null; then
    log_warn "Platform-specific download failed, trying universal package..."
    url="https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

    if ! curl -L -f -o "$output" "$url"; then
      log_error "Failed to download $extension_id"
      return 1
    fi
  fi

  log_info "Downloaded successfully"
}

extract_vsix() {
  local vsix_file=$1
  local extract_dir=$2

  log_info "Extracting $(basename "$vsix_file")..."

  # VSIX files are just ZIP archives
  unzip -q -o "$vsix_file" -d "$extract_dir"
}

setup_roslyn() {
  local extract_dir=$1
  local target_dir=$2

  log_info "Setting up Roslyn language server..."

  # Look for roslyn language server in common locations
  local roslyn_dir=""

  # Check for .roslyn directory (common in newer versions)
  # VSIX extracts to an 'extension' subdirectory
  if [ -d "$extract_dir/extension/.roslyn" ]; then
    roslyn_dir="$extract_dir/extension/.roslyn"
  elif [ -d "$extract_dir/.roslyn" ]; then
    roslyn_dir="$extract_dir/.roslyn"
  elif [ -d "$extract_dir/extension/roslyn" ]; then
    roslyn_dir="$extract_dir/extension/roslyn"
  elif [ -d "$extract_dir/roslyn" ]; then
    roslyn_dir="$extract_dir/roslyn"
  else
    log_error "Could not find roslyn directory in extracted files"
    return 1
  fi

  log_info "Found Roslyn at: $roslyn_dir"

  # Copy to target directory
  mkdir -p "$target_dir/roslyn"
  cp -r "$roslyn_dir"/* "$target_dir/roslyn/"

  # Make executable
  find "$target_dir/roslyn" -type f \( -name "*.dll" -o -name "Microsoft.CodeAnalysis.LanguageServer" -o -name "Microsoft.CodeAnalysis.LanguageServer.exe" \) | while read -r file; do
    chmod +x "$file" 2>/dev/null || true
  done

  log_info "Roslyn installed to: $target_dir/roslyn"
}

setup_razor() {
  local extract_dir=$1
  local target_dir=$2

  log_info "Setting up Razor extension..."

  # Look for razor extension
  local razor_dir=""

  # Check common locations (VSIX extracts to 'extension' subdirectory)
  if [ -d "$extract_dir/extension/.razorExtension" ]; then
    razor_dir="$extract_dir/extension/.razorExtension"
  elif [ -d "$extract_dir/.razorExtension" ]; then
    razor_dir="$extract_dir/.razorExtension"
  elif [ -d "$extract_dir/extension/.razor" ]; then
    razor_dir="$extract_dir/extension/.razor"
  elif [ -d "$extract_dir/.razor" ]; then
    razor_dir="$extract_dir/.razor"
  elif [ -d "$extract_dir/extension/razor" ]; then
    razor_dir="$extract_dir/extension/razor"
  elif [ -d "$extract_dir/razor" ]; then
    razor_dir="$extract_dir/razor"
  else
    # Sometimes it's in a different structure
    log_warn "Could not find dedicated razor directory, searching for razor files..."

    # Look for razor-related files
    razor_files=$(find "$extract_dir" -name "*razor*" -o -name "*Razor*" 2>/dev/null | head -1)
    if [ -n "$razor_files" ]; then
      razor_dir=$(dirname "$razor_files")
    fi
  fi

  if [ -n "$razor_dir" ] && [ -d "$razor_dir" ]; then
    log_info "Found Razor at: $razor_dir"
    mkdir -p "$target_dir/razor"
    cp -r "$razor_dir"/* "$target_dir/razor/"

    # Make executables
    find "$target_dir/razor" -type f \( -name "*.dll" -o -name "rzls" -o -name "*.exe" \) | while read -r file; do
      chmod +x "$file" 2>/dev/null || true
    done

    log_info "Razor installed to: $target_dir/razor"
  else
    log_warn "Razor extension not found in this package"
  fi
}

main() {
  # Parse command line arguments
  local platform_flag="linux"  # Default to linux

  while [[ $# -gt 0 ]]; do
    case $1 in
      --linux)
        platform_flag="linux"
        shift
        ;;
      --mac)
        platform_flag="mac"
        shift
        ;;
      --windows)
        platform_flag="windows"
        shift
        ;;
      -h|--help)
        show_usage
        ;;
      *)
        log_error "Unknown option: $1"
        show_usage
        ;;
    esac
  done

  # Set default install directory if not provided
  if [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR=$(get_default_install_dir "$platform_flag")
  fi

  log_info "Starting Roslyn and Razor installation for Neovim"

  # Check dependencies
  for cmd in curl unzip; do
    if ! command -v $cmd &> /dev/null; then
      log_error "$cmd is required but not installed"
      exit 1
    fi
  done

  # Get platform string
  PLATFORM=$(get_platform_string "$platform_flag")
  log_info "Target platform: $PLATFORM"

  # Get versions
  if [ "$CSHARP_VERSION" = "latest" ]; then
    CSHARP_VERSION=$(get_latest_version "$CSHARP_EXT")
  fi

  if [ "$CSDEVKIT_VERSION" = "latest" ]; then
    CSDEVKIT_VERSION=$(get_latest_version "$CSDEVKIT_EXT")
  fi

  log_info "C# Extension version: $CSHARP_VERSION"
  log_info "C# Dev Kit version: $CSDEVKIT_VERSION"

  # Create temp directory
  TEMP_DIR=$(mktemp -d)
  trap "rm -rf $TEMP_DIR" EXIT

  log_info "Using temp directory: $TEMP_DIR"

  # Download extensions
  CSHARP_VSIX="$TEMP_DIR/csharp.vsix"
  CSDEVKIT_VSIX="$TEMP_DIR/csdevkit.vsix"

  download_vsix "$CSHARP_EXT" "$CSHARP_VERSION" "$PLATFORM" "$CSHARP_VSIX"
  download_vsix "$CSDEVKIT_EXT" "$CSDEVKIT_VERSION" "$PLATFORM" "$CSDEVKIT_VSIX"

  # Extract extensions
  CSHARP_EXTRACT="$TEMP_DIR/csharp_extracted"
  CSDEVKIT_EXTRACT="$TEMP_DIR/csdevkit_extracted"

  extract_vsix "$CSHARP_VSIX" "$CSHARP_EXTRACT"
  extract_vsix "$CSDEVKIT_VSIX" "$CSDEVKIT_EXTRACT"

  # Create install directory
  mkdir -p "$INSTALL_DIR"

  # Setup components
  # Roslyn is typically in the C# extension
  setup_roslyn "$CSHARP_EXTRACT" "$INSTALL_DIR" || setup_roslyn "$CSDEVKIT_EXTRACT" "$INSTALL_DIR"

  # Razor can be in either extension
  setup_razor "$CSHARP_EXTRACT" "$INSTALL_DIR" || setup_razor "$CSDEVKIT_EXTRACT" "$INSTALL_DIR"

  log_info ""
  log_info "============================================"
  log_info "Installation complete!"
  log_info "============================================"
  log_info "Installation directory: $INSTALL_DIR"
  log_info ""
  log_info "Directory structure:"
  log_info "  $INSTALL_DIR/roslyn/  - Roslyn language server"
  log_info "  $INSTALL_DIR/razor/   - Razor extension"
  log_info ""
}

main "$@"
