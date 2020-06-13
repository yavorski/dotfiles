# `sway window manager`

## Install dependencies

```bash
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

```bash
# pacman -S sway swaylock swayidle
# pacman -S xorg-server-xwayland glfw-wayland
```

## Status bar

```bash
# pacman -S i3status
# mkdir ~/.config/i3status
# cp /etc/i3status.conf ~/.config/i3status/config
```

## `vte` terminal

```bash
# pacman -S kitty kitty-terminfo
# pacman -S alacritty alacritty-terminfo
# pacman -S termite termite-terminfo vte-common
# pacman -S rxvt-unicode rxvt-unicode-terminfo community/urxvt-perls
```

## Clipboard Manager for Wayland - `clipman` *`AUR`*

```bash
$ git clone https://aur.archlinux.org/clipman.git
$ cd clipman
$ makepkg -si
```

## App Launcher

Start a terminal in floating window is ok.

Other alternatives are:

```bash
# pacman -S wofi *`AUR`*
# git clone https://aur.archlinux.org/wofi-hg.git && cd $_ && makepkg -si

# pacman -S rofi
# pacman -S dmenu
# pacman -S bemenu
```

## Configure `sway`

```bash
# sudo -iu <username>
$ mkidir -p ~/.congig/sway
$ cp /etc/sway/config ~/.config/sway/
$ exit
```

## Light

```bash
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

```bash
# pacman -S pulseaudio
```

## Source Code Pro Font

```bash
# pacman -S adobe-source-code-pro-fonts
```


## qt

```bash
# pacman -S qt5-wayland
```


---
---

## `i3-wm`

`L390`

* [i3](https://wiki.archlinux.org/index.php/I3)
* [xorg](https://wiki.archlinux.org/index.php/Xorg)
* [xinit](https://wiki.archlinux.org/index.php/Xinit)
* [xorg-apps](https://www.archlinux.org/groups/x86_64/xorg-apps/)

* [px-calc](https://www.pxcalc.com/)
* [dpi-calc](https://www.sven.de/dpi/)

```bash
# pacman -S xorg xorg-xinit xorg-tw mxterm (xorg-server xorg-apps)
# pacman -S llvm clang mcpp python-pyudev python-libevdev
# pacman -S gtk3 argyllcms colord-sane
# pacman -S (qt5) qt5-base
# pacman -S gnome-themes-standard
# pacman -S xss-lock xautolock
# pacman -S picom unclutter
# pacman -S feh imagemagick jpegexiforient
# pacman -S xsel xclip
# pacman -S gnu-free-fonts
# pacman -S libva-utils vdpauinfo
# pacman -S pulseaudio
# pacman -S xorg-fonts-misc xorg-xfontsel xorg-xlsfonts fontconfig  adobe-source-code-pro-fonts
# pacman -S intlfonts ttf-tw (AUR)

$ startx
# xset +fp /usr/share/fonts/misc
# xset +fp /usr/share/fonts/local
# xset +fp /usr/share/fonts/ALL_FOTNS_DIR
$ exit

# cd /usr/share/fonts/encodings
# mkfontscale
# mkfontdir
# xset +fp /usr/share/fonts/encodings
# xset fp rehash
# fc-cache -fv

# pacman -S i3
# pacman -S rxvt-unicode dmenu

# localectl set-locale LANG=en_US.UTF-8
# -> see ~/.bash/.locale -> remove "export" keyword
# localectl --no-convert set-x11-keymap us,bg pc105 ,phonetic grp:win_space_toggle

# ## -> https://wiki.archlinux.org/index.php/HiDPI
# ## -> https://www.youtube.com/watch?v=BXAn_u1UfOQ

# X -configure
# mv /root/xorg.conf/new /etc/X11/xorg.conf
# vim /etc/X11/xorg.conf

# > -> DisplaySize 294.4 165.6 <- (Section "Monitor")
# > -> Modes "1920x1080" <- (Section "Screen" -> SubSection "Display" - Last)

# > -> DisplaySize 650 366 <- (Section "Monitor")
# > -> Modes "3072x1728" <- (Section "Screen" -> SubSection "Display" - Last)

# vim /etc/X11/xinit/xinitrc
# # # -> edit "/etc/X11/xinit/xinitrc" <- -> remove twm & xclock

$ xrandr --current
$ xrdb -query | grep dpi
$ xdpyinfo | grep -B5 resolution

$ xrandr --output eDP-1 --scale 1.6x1.6 --dpi 120 --panning 3072x1728
$ xrandr --output eDP-1 --size 650x366 --scale 1.6x1.6 --dpi 120 --panning 3072x1728

# ### see ./x for more details
# ### create the "~/.xinitrc" file in home dir ### #
$ cp ./x/* ~/
```
