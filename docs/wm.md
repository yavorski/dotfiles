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
# pacman -S xorg-server-xwayland glfw-wayland
```

## Status bar

```
# pacman -S i3status
# mkdir ~/.config/i3status
# cp /etc/i3status/conf ~/.config/i3status/config
```

## Install `vte` terminal

```
# pacman -S kitty kitty-terminfo
# pacman -S alacritty alacritty-terminfo
# pacman -S termite termite-terminfo vte-common
# pacman -S rxvt-unicode rxvt-unicode-terminfo community/urxvt-perls
```

## Install clipboard manager for Wayland - `clipman` *AUR*

```
$ git clone https://aur.archlinux.org/clipman.git
$ cd clipman
$ makepkg -si
```

## App Launcher

```
# pacman -S wofi *AUR*
# git clone https://aur.archlinux.org/wofi-hg.git && cd $_ && makepkg -si

# pacman -S rofi
# pacman -S dmenu
# pacman -S bemenu
```

## Install `nerd-fonts-complete` (*AUR*) - `2GB`

```
$ git clone https://aur.archlinux.org/nerd-fonts-complete.git
$ cd nerd-fonts-complete
$ makepkg -si
```

## Configure `sway`

```
# sudo -iu <username>
$ mkidir -p ~/.congig/sway
$ cp /etc/sway/config ~/.config/sway/
$ exit
```

## Display Manager

```
# pacman -S lightdm
# pacman -S lightdm-gtk-greeter
# systemctl enable lightdm.service
```
