#!/usr/bin/env bash

# change npm's default directory

mkdir -p $HOME/.npm-global
npm config set prefix $HOME/.npm-global

# ./bash/.exports
export PATH=$HOME/.npm-global/bin:$PATH

# alternative with env var only
export NPM_CONFIG_PREFIX=$HOME/.npm-global
