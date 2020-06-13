# ~/.xinitrc
# ------------------------------------------

# xrdb ~/.Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# L390
# xrandr --output eDP1 --auto
# xrandr --output eDP1 --size 650x366 --scale 1.6x1.6 --dpi 120 --panning 3072x1728
xrandr --output eDP1 --scale 1.6x1.6 --dpi 120 --panning 3072x1728 &

exec i3
# unclutter &
# picom -b && exec i3
