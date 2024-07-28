#!/usr/bin/env bash

source bash/.functions

function bootstrap() {
  echo ""
  rsync -avh --no-perms .vimrc .inputrc .gitconfig .shellcheckrc "$HOME"

  echo ""
  rsync -avh --no-perms --delete bash nvim helix kitty alacritty starship/starship.toml "$HOME/.config"

  echo ""
  rsync -avh --no-perms --delete sway waybar "$HOME/.config"

  echo ""
  rsync -avh --no-perms --delete chrome/chrome-flags.conf chrome/chromium-flags.conf "$HOME/.config"

  # bash
  ln -sf "$HOME/.config/bash/.bashrc" "$HOME/.bashrc"
  ln -sf "$HOME/.config/bash/.bash_profile" "$HOME/.bash_profile"

  # source .extra files
  [[ -f .extra ]] && source .extra
  [[ -f $HOME/.extra ]] && source "$HOME/.extra"

  # init new shell
  source "$HOME/.bashrc"
}

if ! command -v rsync &> /dev/null; then
  echo "Error: rsync is not installed or available in PATH"
  exit 1
fi

if [[ "$1" == "-f" || "$1" == "--force" ]]; then
  backup
  bootstrap
else
  read -r -p "This may overwrite existing files in home and home/.cofnig directories. Are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup
    bootstrap
  fi
fi

unset bootstrap
