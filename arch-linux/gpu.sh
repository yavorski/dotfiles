#!/usr/bin/env bash

echo @start GPU script...

lspci -k | grep -A 2 -E "(VGA|3D)"

pacman -Syu nvidia nvidia-settings

# update mkinitcpio conf
NVIDIA_CONF=/etc/modprobe.d/nvidia.conf

touch $NVIDIA_CONF
cat >> $NVIDIA_CONF << EOL
blacklist nouveau
install i915 /usr/bin/false
install intel_agp /usr/bin/false
options nouveau modeset=0
options nvidia-drm modeset=1
EOL

MK_MODULES="MODULES=()"
MK_MODULES_NEW="MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
sed -i "s|$MK_MODULES|$MK_MODULES_NEW|" /etc/mkinitcpio.conf

MK_FILES="FILES=()"
MK_FILES_NEW="FILES=($NVIDIA_CONF)"
sed -i "s|$MK_FILES|$MK_FILES_NEW|" /etc/mkinitcpio.conf

mkinitcpio -p linux

# update grub
DV="loglevel=3 quiet"
NV="nouveau.blacklist=1 nvidia-drm.modeset=1"
GD="GRUB_CMDLINE_LINUX_DEFAULT=\"$DV\""
GDN="GRUB_CMDLINE_LINUX_DEFAULT=\"$DV $NV\""
sed -i "s|$GD|$GDN|" /etc/default/grub

# # -> GRUB_TERMINAL_OUTPUT=console
# # -> comment GRUB_GFXMODE
# # -> comment GRUB_GFXPAYLOAD_LINUX

grub-mkconfig --output /boot/grub/grub.cfg

echo @set nvidia.hook

NVIDIA_HOOK="/etc/pacman.d/hooks/nvidia.hook"

mkdir -p /etc/pacman.d/hooks
touch $NVIDIA_HOOK

cat >> $NVIDIA_HOOK << EOL
# $NVIDIA_HOOK
# -------------------------------
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOL


#
echo @finish GPU script!

# echo @reboot
# systemctl reboot

# <!#> check if nouveau driver is loader after reboot
# lsmod | grep nouveau
# rmmod nouveau ### -> ### Should output "Module nouveau is not currently loaded"
# journalctl -b | grep nouveau ### -> ### Should say that nouveau is blacklisted
