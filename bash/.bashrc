#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

# Set dotfiles dir var
export DOTFILES=$HOME/.config/bash

# Source bash profile
[[ -f $DOTFILES/.profile ]] && source $DOTFILES/.profile;
