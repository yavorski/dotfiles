#!/usr/bin/env bash

function backup() {
  [ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.BAK;
  [ -f ~/.profile ] && cp ~/.profile ~/.profile.BAK;
  [ -f ~/.bash_profile ] && cp ~/.bash_profile ~/.bash_profile.BAK;
  [ -f ~/.inputrc ] && cp ~/.inputrc ~/.inputrc.BAK;
  [ -f ~/.gitconfig ] && cp ~/.gitconfig ~/.gitconfig.BAK;
}

backup;

unset backup;

