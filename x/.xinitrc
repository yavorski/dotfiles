# ~/.xinitrc
# ------------------------------------------

# xrdb ~/.Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

exec i3
# unclutter &
# picom -b && exec i3
