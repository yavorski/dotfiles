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
# cp /etc/i3status.conf ~/.config/i3status/config
```

## `vte` terminal

```
# pacman -S kitty kitty-terminfo
# pacman -S alacritty alacritty-terminfo
# pacman -S termite termite-terminfo vte-common
# pacman -S rxvt-unicode rxvt-unicode-terminfo community/urxvt-perls
```

## Clipboard Manager for Wayland - `clipman` *`AUR`*

```
$ git clone https://aur.archlinux.org/clipman.git
$ cd clipman
$ makepkg -si
```

## App Launcher

Start a terminal in floating window is ok.

Other alternatives are:

```
# pacman -S wofi *`AUR`*
# git clone https://aur.archlinux.org/wofi-hg.git && cd $_ && makepkg -si

# pacman -S rofi
# pacman -S dmenu
# pacman -S bemenu
```

## Configure `sway`

```
# sudo -iu <username>
$ mkidir -p ~/.congig/sway
$ cp /etc/sway/config ~/.config/sway/
$ exit
```

## Light

```
# pacman -S light
# usermod -a -G video <username>
# light -A 5
# light -U 5

# in sway config
> bindsym XF86MonBrightnessUp exec light -A 5
> bindsym XF86MonBrightnessDown exec light -U 5

# turn on/off power light
# light -Ss sysfs/leds/tpacpi::power 0
# light -Ss sysfs/leds/tpacpi::power 1
```

## PulseAudio

```
# pacman -S pulseaudio
```

## Source Code Pro Font

```
# pacman -S adobe-source-code-pro-fonts
```

## Nerd Fonts *`AUR`* - `2GB`

```
$ git clone https://aur.archlinux.org/nerd-fonts-complete.git
$ cd nerd-fonts-complete
$ makepkg -si
```

## qt

```
# pacman -S qt5-wayland
```


---
---

## `i3-wm`

* [i3](https://wiki.archlinux.org/index.php/I3)
* [xorg](https://wiki.archlinux.org/index.php/Xorg)
* [xinit](https://wiki.archlinux.org/index.php/Xinit)
* [xorg apps](https://www.archlinux.org/groups/x86_64/xorg-apps/)
* [pxcalc](https://www.pxcalc.com/)


```bash
# pacman -S i3
# pacman -S xorg-server xorg-xinit xorg-apps
# pacman -S xss-lock xautolock
# pacman -S picom unclutter
# pacman -S feh
# pacman -S xsel xclip

# ### check vga ### #
$ xrandr
$ lspci | grep -e VGA -e 3D

# ### L390 - intel video ### #
# => => pacman -S xf86-video-intel

# ### check if your display size and DPI are detected/calculated correctly ### #
$ xdpyinfo | grep -B2 resolution

# ### set DPI for L390 ### #
# ### 120 is 25% more from 96dpi which is the default) ### #
xrandr --dpi 120

# ### see ./x for more details
# ### create the "~/.xinitrc" file in home dir ### #
$ cp ./x/* ~/
```
