#!/usr/bin/env bash

function backup() {
  [ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.BAK;
  [ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.BAK;
  [ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.BAK;
}

function bootstrap() {
  # Copy files to ~/.config
  rsync .inputrc .gitconfig -avh --no-perms $HOME;
  rsync bash vim nvim -avh --no-perms --delete $HOME/.config;

  # Link files from ~/.config
  ln -s $HOME/.config/bash/.bashrc $HOME/.bashrc;

  # mv ~/vim ~/.vim
  # mv ~/.vim/.vimrc ~;
  # mv ~/nvim ~/.config/
  source ~/.bashrc;
  # curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
  # curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
