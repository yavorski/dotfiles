#!/usr/bin/env bash

clean=false
windows=false
source_directory="$HOME/dev/dotfiles/nvim/"
destination_directory="$HOME/.config/nvim/"

for arg in "$@"; do
  if [ "$arg" = '--clean' ]; then
    clean=true
  fi
  if [ "$arg" = '--sync-windows' ]; then
    windows=true
  fi
done

if [ "$windows" = true ]; then
  echo 'Sync Neovim config from WSL to Windows'
  appdata=$("/mnt/c/Program Files/PowerShell/7/pwsh.exe" -NoProfile -Command '$env:LOCALAPPDATA' | tr -d '\r')
  appdata_wsl=$(wslpath "$appdata")
  appdata_neovim="$appdata_wsl/nvim/"
  destination_directory="$appdata_neovim"
fi

# Sync files
rsync -avh --no-perms --delete --exclude='nvim-pack-lock.json' "$source_directory" "$destination_directory"

# Clean data and state dirs
if [ "$clean" = true ]; then
  echo 'Cleaning Neovim state and data directories'
  if [ "$windows" = true ]; then
    rm -rf "$appdata_wsl/nvim-data/"
  else
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.local/share/nvim"
  fi
fi
