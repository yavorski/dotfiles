#!/usr/bin/env bash

echo @start post-install script ...

pacman -Syu

pacman -S intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S expat ufw unbound

ufw enable
ufw status verbose
systemctl enable ufw

# pacman -S powertop
# powertop --auto-tune

yes | pacman -S cronie
# crontab -e -> add "@reboot powertop --auto-tune"

yes | pacman -S git
yes | pacman -S tree htop
yes | pacman -S curl wget rsync
yes | pacman -S llvm gcc clang cmake python rust nodejs npm
yes | pacman -S exa bat fzf ripgrep the_silver_searcher
yes | pacman -S gnu-free-fonts powerline-fonts adobe-source-code-pro-fonts
yes | pacman -S neovim
yes | pacman -S starship
yes | pacman -S alacritty kitty

yes | pacman -S xorg-xdpyinfo xorg-xprop xorg-xrandr xorg-xwininfo
yes | pacman -S neofetch catimg chafa feh imagemagick jp2a libcaca nitrogen

# @todo update service
yes | pacman -Syu reflector

echo @finish post-install script!
