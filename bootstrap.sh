#!/usr/bin/env bash

function backup() {
  [ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.BAK;
  [ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.BAK;
  [ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.BAK;
}

function bootstrap() {
  # Copy files to ~/.config
  printf "\n";
  rsync .inputrc .gitconfig -avh --no-perms $HOME;

  printf "\n";
  rsync bash vim nvim -avh --no-perms --delete $HOME/.config;

  # Link files from ~/.config (no need to link nvim)
  ln -s $HOME/.config/bash/.bashrc $HOME/.bashrc;
  ln -s $HOME/.config/vim/.vimrc $HOME/.vimrc;
  ln -s $HOME/.config/vim $HOME/.vim;

  # init new shell
  source $HOME/.bashrc;

  # init vim plug
  printf "\n";
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;

  # init nvim plug
  printf "\n";
  curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  backup;
  bootstrap;
else
  read -p "This may overwrite existing files in home and home/.cofnig directories. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup;
    bootstrap;
  fi;
fi;
unset bootstrap;
