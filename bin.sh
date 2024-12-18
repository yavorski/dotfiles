#!/usr/bin/env bash

read -r -p "Install dotfiles/bin scripts to /usr/local/bin -> Are you sure? (y/n) " -n 1
echo ""

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  if sudo cp ./bin/*.sh /usr/local/bin; then
    echo "Scripts successfully copied to /usr/local/bin"
  else
    echo "Failed to copy scripts. Please check permissions or paths"
  fi
else
  echo "Operation canceled"
fi
