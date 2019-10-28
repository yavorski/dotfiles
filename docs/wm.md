# `sway window manager`

## Install dependencies

```
# pacman -S meson
# pacman -S wlroots
# pacman -S wayland
# pacman -S wayland-protocols
# pacman -S pcre
# pacman -S json-c
# pacman -S pango
# pacman -S cairo
# pacman -S gdk-pixbuf2
# pacman -S scdoc
# pacman -S gtk3 *
```

## Install `sway`

```
# pacman -S sway swaylock swayidle
# pacman -S rofi dmenu bemenu i3status
# pacman -S xorg-server-xwayland glfw-wayland
```

## Install `vte` terminal

```
# pacman -S kitty kitty-terminfo
# pacman -S alacritty alacritty-terminfo
# pacman -S rxvt-unicode rxvt-unicode-terminfo urxvt-perls

```

## Configure `sway`

```
# sudo -iu <username>
$ mkidir -p ~/.congig/sway
$ cp /etc/sway/config ~/.config/sway/
$ exit
```

## Install `nerd-fonts-complete` (*AUR*) - `2GB`

```
$ git clone https://aur.archlinux.org/nerd-fonts-complete.git
$ cd nerd-fonts-complete
$ makepkg -si
```
