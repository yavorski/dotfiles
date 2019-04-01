#!/usr/bin/env bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.

declare -a files=(
  $DOTFILES/.settings
  $DOTFILES/.exports
  $DOTFILES/.aliases
  $DOTFILES/.prompt
  $DOTFILES/.path
  $DOTFILES/.extra
  $HOME/.path
  $HOME/.extra
);

for file in ${files[@]}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

unset file;
unset files;

# Open new terminal tab in the same/current dir
if [ -e /etc/profile.d/vte.sh ]; then
  source /etc/profile.d/vte.sh;
fi;

# Enable programmable completion features
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
