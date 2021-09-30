# `sway window manager`

## Install `sway`

```bash
# pacman -S sway swaylock swayidle
# pacman -S xorg-server-xwayland glfw-wayland
```

## Status bar

* `waybar`
* `i3status`

## Clipboard Manager for Wayland

* `wl-clipboard`

## App Launcher

Start a terminal in floating window is ok.

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

