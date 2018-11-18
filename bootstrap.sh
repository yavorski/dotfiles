#!/usr/bin/env bash

function bootstrap() {
  rsync vim nvim bash/ .gitconfig .editorconfig -avh --no-perms ~;
  mv ~/vim ~/.vim
  mv ~/.vim/.vimrc ~;
  mv ~/nvim ~/.config/
  source ~/.bash_profile;
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  bootstrap;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    bootstrap;
  fi;
fi;
unset bootstrap;
