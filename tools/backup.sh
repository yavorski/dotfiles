#!/usr/bin/env bash

function backup() {
  [ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.BAK;
  [ -f ~/.profile ] && mv ~/.profile ~/.profile.BAK;
  [ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.BAK;
  [ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.BAK;
  [ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.BAK;
  [ -f ~/.vimrc] && mv ~/.vimrc ~/.vimrc.BAK;
  [ -f ~/.gvimrc] && mv ~/.gvimrc ~/.gvimrc.BAK;
  [ -f ~/.vimpagerrc] && mv ~/.vimpagerrc ~/.vimpagerrc.BAK;
}

backup;

unset backup;

