#!/usr/bin/env bash

echo @start chroot script...

HOSTNAME=arch
USERNAME=thinker
HOME_DIR="/home/${USERNAME}"

echo @settings HDD_DISK="$1", SSD_DISK="$2", HOSTNAME="$HOSTNAME", USERNAME="$USERNAME", HOME_DIR="$HOME_DIR"

# initialize pacman keyring
pacman-key --init

# verifying the master keys
pacman-key --populate archlinux

# install base system
pacman -S grub efibootmgr os-prober linux linux-headers linux-firmware mkinitcpio lvm2
pacman -S sudo bash bash-completion man ntp openssh vim terminus-font ttf-dejavu freetype2

systemctl enable sshd
systemctl enable ntpd

# use vim
echo -e "EDITOR=vim" > /etc/environment

# set console font
echo KEYMAP=us > /etc/vconsole.conf
echo FONT=ter-v16b >> /etc/vconsole.conf


# update mkinitcpio
DEFAULT_HOOKS="HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)"
UPDATED_HOOKS="HOOKS=(base udev autodetect modconf block consolefont encrypt lvm2 filesystems keyboard fsck)"

# update hooks
echo @update-hooks
sed -i "s/$DEFAULT_HOOKS/$UPDATED_HOOKS/" /etc/mkinitcpio.conf

# create an initial ramdisk environment
mkinitcpio -p linux


# update grub
echo @update-grub
sed -i "s/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/" /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cryptdevice=\/dev\/sdb3:vg-ssd"/' /etc/default/grub


# mount EFI
mkdir /boot/EFI
mount /dev/sdb1 /boot/EFI


# grub
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

mkdir -p /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

grub-mkconfig -o /boot/grub/grub.cfg

# grub font
grub-mkfont -o /boot/grub/fonts/ter.pf2 --size 20 /usr/share/fonts/misc/ter-x20b.pcf.gz

echo "# FONT" >> /etc/default/grub
echo "GRUB_FONT=/boot/grub/fonts/ter.pf2" >> /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg


# root password
echo @set root password
passwd


# local time
ln -sf /usr/share/zoneinfo/Europe/Sofia /etc/localtime

# clock
hwclock --systohc
# hwclock --systohc --utc

# locale
echo @update-locale
sed -i "s/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/#bg_BG.UTF-8 UTF-8/bg_BG.UTF-8 UTF-8/" /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LC_TIME=en_GB.UTF-8 >> /etc/locale.conf


# network
# @todo replace networkmanager with systemd and resolvd
yes | pacman -Syu networkmanager
echo $HOSTNAME > /etc/hostname

# /etc/hosts
echo "#" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 arch.local arch" >> /etc/hosts

# /etc/resolv.conf
echo "#" >> /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.8.4" >> /etc/resolv.conf

systemctl disable dhcpcd
systemctl enable NetworkManager


# add user
useradd -m -g users -G wheel $USERNAME

echo @enter password for $USERNAME
passwd $USERNAME

# allow members of wheel group to execute any command
# echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo @update /etc/sudoers
sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers


# add public key to root for ssh key access
mkdir -m 700 /root/.ssh
cp /authorized_keys /root/.ssh

# add public key to user for ssh key access
mkdir -m 700 "$HOME_DIR/.ssh"
cp /authorized_keys "$HOME_DIR/.ssh"
chown -R "$USERNAME:$USERNAME" "$HOME_DIR/.ssh"

# cp post install script in user home dir
cp /gpu.sh $HOME_DIR
cp /post-install.sh $HOME_DIR


#
source /gpu.sh

#
source /post-install.sh

#
echo @finish chroot.sh script!

# exit chroot
exit
