#!/usr/bin/env bash

#
# Debian instasll vimpager
#

REPO_DIR="$HOME/dev/vimpager"

rm -r $REPO_DIR

git clone git://github.com/rkitover/vimpager $REPO_DIR

cd $REPO_DIR

sudo make install-deb

unset REPO_DIR
