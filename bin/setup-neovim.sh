#!/usr/bin/env bash

windows=false
source_directory="$HOME/dev/dotfiles/nvim/"
destination_directory="$HOME/.config/nvim/"

for arg in "$@"; do
  if [ "$arg" = '--sync-windows' ]; then
    windows=true
    break
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
rsync -avh --no-perms --delete --exclude='lazy-lock.json' "$source_directory" "$destination_directory"
