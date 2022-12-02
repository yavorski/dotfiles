#!/usr/bin/env bash

source bash/.functions

function bootstrap() {
  echo ""
  rsync .inputrc .gitconfig -avh --no-perms $HOME

  echo ""
  rsync bash vim nvim -avh --no-perms --delete $HOME/.config

  echo ""
  # rsync i3 i3status -avh --no-perms --delete $HOME/.config
  rsync alacritty kitty sway starship/starship.toml -avh --no-perms --delete $HOME/.config

  # bash
  ln -sf $HOME/.config/bash/.bashrc $HOME/.bashrc
  ln -sf $HOME/.config/bash/.bash_profile $HOME/.bash_profile

  # vim
  ln -sf $HOME/.config/vim $HOME/.vim
  ln -sf $HOME/.config/vim/.vimrc $HOME/.vimrc
  ln -sf $HOME/.config/vim/.gvimrc $HOME/.gvimrc
  ln -sf $HOME/.config/vim/.vimpagerrc $HOME/.vimpagerrc

  # init new shell
  source .extra
  source $HOME/.bashrc

  # init vim plug
  echo ""
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # sublime-text-3
  # echo ""
  # local SUBL_PKG_CTRL="Package Control.sublime-package"
  # curl -fLo "$HOME/.config/sublime-text-3/Installed Packages/$SUBL_PKG_CTRL" --create-dirs "https://packagecontrol.io/$SUBL_PKG_CTRL"
  # rsync sublime/* -avh --mkpath --no-perms --delete $HOME/.config/sublime-text-3/Packages/User
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
  backup
  bootstrap
else
  read -p "This may overwrite existing files in home and home/.cofnig directories. Are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup
    bootstrap
  fi
fi

unset bootstrap

