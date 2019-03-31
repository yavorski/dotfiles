#!/usr/bin/env bash

function rmbackup() {
  [ -f ~/.bashrc.BAK ] && rm ~/.bashrc.BAK;
  [ -f ~/.profile ] && rm ~/.profile.BAK;
  [ -f ~/.bash_profile ] && rm ~/.bash_profile.BAK;
  [ -f ~/.inputrc.BAK ] && rm ~/.inputrc.BAK;
  [ -f ~/.gitconfig.BAK ] && rm ~/.gitconfig.BAK;
}

rmbackup;
