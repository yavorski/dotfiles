#!/usr/bin/env bash

function backup() {
  mkdir -p ~/.bak
  [ -f ~/.bashrc ] && mv ~/.bashrc ~/.bak
  [ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bak
  [ -f ~/.profile ] && mv ~/.profile ~/.bak
  [ -f ~/.inputrc ] && mv ~/.inputrc ~/.bak
  [ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.bak
  [ -f ~/.vimrc] && mv ~/.vimrc ~/.bak
  [ -f ~/.gvimrc] && mv ~/.gvimrc ~/.bak
  [ -f ~/.vimpagerrc] && mv ~/.vimpagerrc ~/.bak
}

backup

unset backup

