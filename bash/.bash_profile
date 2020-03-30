#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


## start sway ##
# if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#   exec sway
#   # XKB_DEFAULT_LAYOUT=us exec sway -d 2> ~/dev/sway.log
# fi


## start i3 ##
# if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#   exec startx
# fi
