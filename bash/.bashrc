#!/usr/bin/env bash
# ----------------------------------------

# ~/.bashrc
# ----------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

# Set dotfiles dir var
export DOTFILES=$HOME/.config/bash

# Init dotfiles
[[ -f $DOTFILES/.init ]] && source "$DOTFILES/.init"
