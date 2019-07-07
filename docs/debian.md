# Debian Buster

## `/etc/apt/sources.list`

```shell
# debian /etc/apt/sources.list

deb https://deb.debian.org/debian buster main contrib non-free
deb-src https://deb.debian.org/debian buster main contrib non-free


deb https://deb.debian.org/debian buster-updates main contrib non-free
deb-src https://deb.debian.org/debian buster-updates main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free
```

## Packages

* `git`
* `htop`
* `curl`
* `wget`
* `vim-gtk3` (+clipboard support)
* `vimpager`
* `nvidia-detect`
* `nvidia-driver`
* `bash-completion`
* `silversearcher-ag`
* `apt-transport-https`
* `numix-gtk-theme`

## Gnome extensions

* [`AppKeys dash hotkeys`](https://extensions.gnome.org/extension/413/dash-hotkeys)
* [`Apt updates indicator`](https://extensions.gnome.org/extension/1139/apt-update-indicator)
* [`Remove rounded corners`](https://extensions.gnome.org/extension/448/remove-rounded-corners)
* [`How to install gnome extension`](https://gist.github.com/yavorski/cf6e3f8f25c7c2e29f0651131ed611b4)

## Nvidia Drivers

Refer to

* [Debian Wiki](https://wiki.debian.org/NvidiaGraphicsDrivers)

## Network fix for `r8168(9)`

Refer to

* [Fix r8168 Realtek Linux Issue](https://www.unixblogger.com/how-to-get-your-realtek-rtl8111rtl8168-working-updated-guide)

