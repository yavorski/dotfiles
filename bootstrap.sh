#!/usr/bin/env bash

source bash/.functions

function bootstrap() {
  # copy files to ~/.config
  printf "\n"
  rsync .inputrc .gitconfig -avh --no-perms $HOME

  printf "\n"
  rsync bash vim nvim -avh --no-perms --delete $HOME/.config

  printf "SWAY \n"
  rsync alacritty kitty sway i3 i3status starship/starship.toml -avh --no-perms --delete $HOME/.config

  # link files from ~/.config
  # no need to link `nvim` ~/.config/nvim/init.vim

  ln -sf $HOME/.config/bash/.bashrc $HOME/.bashrc
  ln -sf $HOME/.config/bash/.bash_profile $HOME/.bash_profile

  ln -sf $HOME/.config/vim $HOME/.vim
  ln -sf $HOME/.config/vim/.vimrc $HOME/.vimrc
  ln -sf $HOME/.config/vim/.gvimrc $HOME/.gvimrc
  ln -sf $HOME/.config/vim/.vimpagerrc $HOME/.vimpagerrc

  # init new shell
  source .extra
  source $HOME/.bashrc

  # init vim plug
  printf "init vim \n"
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # init nvim plug
  printf "init neovim \n"
  curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # sublime-text-3
  printf "init sublime-text-3 \n"
  local SUBL_PKG_CTRL="Package Control.sublime-package"
  curl -fLo "$HOME/.config/sublime-text-3/Installed Packages/$SUBL_PKG_CTRL" --create-dirs "https://packagecontrol.io/$SUBL_PKG_CTRL"
  rsync sublime/* -avh --mkpath --no-perms --delete $HOME/.config/sublime-text-3/Packages/User
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

