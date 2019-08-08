#!/usr/bin/env bash

function rmbackup() {
  [ -f ~/.bashrc.BAK ] && rm ~/.bashrc.BAK;
  [ -f ~/.profile.BAK ] && rm ~/.profile.BAK;
  [ -f ~/.bash_profile.BAK ] && rm ~/.bash_profile.BAK;
  [ -f ~/.inputrc.BAK ] && rm ~/.inputrc.BAK;
  [ -f ~/.gitconfig.BAK ] && rm ~/.gitconfig.BAK;
  [ -f ~/.vimrc.BAK] && rm ~/.vimrc.BAK;
  [ -f ~/.gvimrc.BAK] && rm ~/.gvimrc.BAK;
  [ -f ~/.vimpagerrc.BAK] && rm ~/.vimpagerrc.BAK;
}

rmbackup;

unset rmbackup;
