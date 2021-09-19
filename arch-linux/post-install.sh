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

# reflector
yes | pacman -Syu reflector

# setup reflector options
REFLECTOR_CONF="/etc/xdg/reflector/reflector.conf"
mv $REFLECTOR_CONF "$REFLECTOR_CONF.BAK"
touch $REFLECTOR_CONF
cat >> $REFLECTOR_CONF << EOL
# $REFLECTOR_CONF
# ------------------------------------------
--age 24
--latest 128
--protocol https
--sort rate
--sort score
--sort country
--country 'BG,RO,HU,SI,CZ,NL,PL,UA,CH,DE,FR,IT,FR,DK,LT,LV,EE,FI,NO,SE,GB,PT,RU,CA,US,*,CN'
--save /etc/pacman.d/mirrorlist
EOL

echo @finish post-install script!
