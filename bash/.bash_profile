#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

## start x/i3 ##
# if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#   exec startx
#   # exec startx /usr/bin/i3
# fi

# ## start sway ##
# if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
#   exec sway
#   # XKB_DEFAULT_LAYOUT=us exec sway -d 2> ~/dev/sway.log
# fi
