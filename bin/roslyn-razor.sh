#!/usr/bin/env bash
#
# Install the Roslyn language server and Razor extension from the ms-dotnettools.csharp VS Code extension, for use with Neovim.

set -euo pipefail

readonly EXT_ID="ms-dotnettools.csharp"
readonly MARKETPLACE_URL="https://marketplace.visualstudio.com/items?itemName=${EXT_ID}"

# Defaults
PLATFORM_FLAG="linux"
USE_VERSION="stable"
INSTALL_DIR=""
TMP_DIR=""

trap 'rm -rf "${TMP_DIR:-}"' EXIT

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
err() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
die() { err "$*"; exit 1; }

show_usage() {
  cat <<EOF
Usage: $0 [--linux|--mac|--windows] [--use-version <version>] [--install-dir <path>]

Platform flags (default: --linux):
  --linux                 Linux x64/ARM64
  --mac                   macOS x64/ARM64
  --windows               Windows x64

Version selection:
  --use-version <ver>     One of: 'stable' (default), 'latest', or an
                          explicit version like 2.134.7.
                          'stable' = latest even-minor release (e.g. 2.134.x)
                          'latest' = absolute newest, may be a pre-release

Install location:
  --install-dir <path>    Install directory.
                          Default: ~/dev/roslyn-razor
                                   (/mnt/c/dev/roslyn-razor for --windows)

Examples:
  $0
  $0 --mac --use-version latest
  $0 --windows --use-version 2.134.7
  $0 --install-dir /opt/roslyn-razor
EOF
  exit 0
}

resolve_platform() {
  local arch
  arch=$(uname -m)

  case "$PLATFORM_FLAG:$arch" in
    linux:x86_64)              echo "linux-x64" ;;
    linux:aarch64|linux:arm64) echo "linux-arm64" ;;
    mac:x86_64)                echo "darwin-x64" ;;
    mac:arm64)                 echo "darwin-arm64" ;;
    windows:*)                 echo "win32-x64" ;;
    linux:*|mac:*)             die "Unsupported architecture: $arch" ;;
    *)                         die "Invalid platform: $PLATFORM_FLAG" ;;
  esac
}

default_install_dir() {
  if [ "$PLATFORM_FLAG" = "windows" ]; then
    echo "/mnt/c/dev/roslyn-razor"
  else
    echo "$HOME/dev/roslyn-razor"
  fi
}

# Pick the first version from the marketplace page.
# If $1 is "stable", filter to even-minor versions (Microsoft's stable convention for ms-dotnettools.csharp: even minor = stable, odd minor = pre-release).
fetch_version() {
  local channel=$1
  local filter='{ print; exit }'
  [ "$channel" = "stable" ] && filter='$2 % 2 == 0 { print; exit }'

  log "Fetching $channel version for $EXT_ID..."
  local version
  version=$(curl -sL "$MARKETPLACE_URL" | grep -oP '"version":"[^"]+' | cut -d'"' -f4 | awk -F. "$filter")

  [ -n "$version" ] || die "Failed to fetch $channel version"
  echo "$version"
}

resolve_version() {
  case "$USE_VERSION" in
    stable|latest) fetch_version "$USE_VERSION" ;;
    *)             echo "$USE_VERSION" ;;
  esac
}

download_vsix() {
  local version=$1 platform=$2 output=$3
  local url="https://ms-dotnettools.gallery.vsassets.io/_apis/public/gallery/publisher/ms-dotnettools/extension/csharp/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=${platform}"

  log "Downloading $EXT_ID v$version ($platform)..."
  curl -fsSL -o "$output" "$url" || die "Download failed: $url"
}

install_component() {
  local name=$1 src=$2 dest=$3

  [ -d "$src" ] || die "Missing $name directory in extracted VSIX: $src"

  log "Installing $name -> $dest"
  mkdir -p "$dest"
  cp -r "$src"/* "$dest/"
  find "$dest" -type f \( -name "*.dll" -o -name "*.exe" \
    -o -name "Microsoft.CodeAnalysis.LanguageServer" -o -name "rzls" \) \
    -exec chmod +x {} + 2>/dev/null || true
}

main() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --linux|--mac|--windows) PLATFORM_FLAG="${1#--}"; shift ;;
      --use-version)
        [ -n "${2:-}" ] || die "--use-version requires an argument"
        USE_VERSION="$2"
        shift 2
        ;;
      --install-dir)
        [ -n "${2:-}" ] || die "--install-dir requires an argument"
        INSTALL_DIR="$2"
        shift 2
        ;;
      -h|--help) show_usage ;;
      *)         err "Unknown option: $1"; show_usage ;;
    esac
  done

  for cmd in curl unzip awk grep; do
    command -v "$cmd" >/dev/null || die "$cmd is required but not installed"
  done

  [ -n "$INSTALL_DIR" ] || INSTALL_DIR=$(default_install_dir)

  local platform
  platform=$(resolve_platform)

  local version
  version=$(resolve_version)

  log "Platform:     $platform"
  log "Version:      $version"
  log "Install dir:  $INSTALL_DIR"

  TMP_DIR=$(mktemp -d)

  local vsix="$TMP_DIR/csharp.vsix"
  download_vsix "$version" "$platform" "$vsix"

  log "Extracting VSIX..."
  unzip -q -o "$vsix" -d "$TMP_DIR/extracted"

  install_component "Roslyn" "$TMP_DIR/extracted/extension/.roslyn"         "$INSTALL_DIR/roslyn"
  install_component "Razor"  "$TMP_DIR/extracted/extension/.razorExtension" "$INSTALL_DIR/razor"

  log "Done. Installed to $INSTALL_DIR"
}

main "$@"
