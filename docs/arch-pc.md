```shell
# ip link
# ping 1.1.1.1 -c 4
# timedatectl set-ntp true
# timedatectl status
# pacman -Sy terminus-font
# setfont ter-v16b
# ls /sys/firmware/efi/efivars

# fdisk -l
# fdisk /dev/sdb
# -> p g n
# # /dev/sdb1 - efi  -> 1GB (1) EFI System
# # /dev/sdb2 - boot -> 1GB (20) Linux filesystem
# # /dev/sdb3 - lvm  -> 400GB (31) Linux LVM
# -> p w

# cryptsetup -y -v luksFormat --type luks1 /dev/sdb2
# cryptsetup open --type luks1 /dev/sdb2 crypto-boot

# cryptsetup -y -v luksFormat /dev/sdb3
# cryptsetup open --type luks /dev/sdb3 lvm

# pvcreate --dataalignment 1m /dev/mapper/lvm
# vgcreate vg /dev/mapper/lvm

# lvcreate -L 8GB vg -n lv-swap
# lvcreate -L 40GB vg -n lv-root
# lvcreate -l 100%FREE -n lv-home vg

# lsblk
# modprobe dm_mod
# vgscan
# vgchange -ay

# mkswap /dev/vg/lv-swap
# swapon /dev/vg/lv-swap

# mkfs.ext4 /dev/vg/lv-root
# mount /dev/vg/lv-root /mnt

# mkdir /mnt/boot
# mkfs.ext4 /dev/mapper/crypto-boot
# mount /dev/mapper/crypto-boot /mnt/boot

# mkdir /mnt/home
# mkfs.ext4 /dev/vg/lv-home
# mount /dev/vg/lv-home /mnt/home

# # will mount later
# mkfs.vfat -F32 /dev/sdb1

# pacstrap -i /mnt base base-devel vim
# genfstab -U /mnt >> /mnt/etc/fstab

# lsblk
# blkid
# blkid >> /tmp/blkinf
# vim /tmp/blkinf # -> copy /dev/sdb2 UUID
# vim /mnt/etc/crypttab # -> use /dev/sdb2 UUID
# # -> crypto-boot UUID=</dev/sdb2-UUID> none luks1

# #
# arch-chroot /mnt

# pacman-key --init
# pacman-key --populate archlinux

# pacman -S grub efibootmgr os-prober linux-headers terminus-font

# echo KEYMAP=us >> /etc/vconsole.conf
# echo FONT=ter-v16b >> /etc/vconsole.conf

# vim /etc/mkinitcpio.conf
# # -> add to HOOKS -> `encrypt lvm2` after `block` and before `filesystems`
# # -> add to HOOKS -> `keyboard consolefont` before `autodetect`

# mkinitcpio -p linux

# vim /etc/default/grub
# # -> GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=/dev/sdb3:vg"
# # -> GRUB_ENABLE_CRYPTODISK=y

# mkdir /boot/EFI
# mount /dev/sdb1 /boot/EFI

# grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck /dev/sdb

# mkdir /boot/grub/locale
# cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

# grub-mkconfig -o /boot/grub/grub.cfg

# passwd

# ln -sf /usr/share/zoneinfo/Europe/Sofia /etc/localtime
# hwclock --systohc

# vim /etc/locale.gen
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo LC_TIME=en_GB.UTF-8 >> /etc/locale.conf

# echo arch > /etc/hostname
# vim /etc/hosts # -> change hostname to arch
# vim /etc/resolv.conf

# # -> nameserver 1.1.1.1
# # -> nameserver 1.0.0.1
# # -> nameserver 8.8.8.8
# # -> nameserver 8.8.8.4

# pacman -S networkmanager
# systemctl enable NetworkManager
# systemctl disable dhcpcd
# systemctl start NetworkManager

# exit
# # exit arch-chroot

# umount -R /mnt
# reboot

# # after reboot

# pacman -Syu

# chmod 700 /boot /etc/iptables /etc/arptables
# vim /etc/pam.d/system-login
# # -> "auth required pam_tally2.so deny=5 unlock_time=600 onerr=succeed file=/var/log/tallylog"

# # pacman -S unbound expat

# pacman -S intel-ucode
# grub-mkconfig -o /boot/grub/grub.cfg

# pacman -S ufw
# ufw enable
# ufw status verbose
# systemctl enable ufw

# systemctl --failed
# journalctl -p 3 -xb

# useradd -m -g users -G wheel <username>
# passwd <username>
# EDITOR=vim visudo
# # -> uncomment %wheel group
# pacman -S sudo

# reboot


# # -> nvidia

# lspci -k | grep -A 2 -E "(VGA|3D)"
# pacman -S nvidia nvidia-utils nvidia-settings

# vim /etc/modprobe.d/nvidia.conf
# # -> install i915 /usr/bin/false
# # -> install intel_agp /usr/bin/false
# # -> blacklist nouveau
# # -> options nouveau modeset=0
# # -> options nvidia-drm modeset=1

# vim /etc/mkinitcpio.conf
# # -> MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
# # -> FILES=(/etc/modprobe.d/nvidia.conf)

# mkinitcpio -p linux

# vim /etc/default/grub
# # -> GRUB_CMDLINE_LINUX_DEFAULT="nouveau.blacklist=1 nvidia-drm.modeset=1"
# # -> GRUB_TERMINAL_OUTPUT=console
# # -> comment GRUB_GFXMODE
# # -> comment GRUB_GFXPAYLOAD_LINUX

# grub-mkconfig --output /boot/grub/grub.cfg


# vim /etc/pacman.d/hooks/nvidia.hook
# -> [Trigger]
# -> Operation=Install
# -> Operation=Upgrade
# -> Operation=Remove
# -> Type=Package
# -> Target=nvidia
# -> Target=linux
# -> # Change the linux part above and in the Exec line if a different kernel is used
# ->
# -> [Action]
# -> Description=Update Nvidia module in initcpio
# -> Depends=mkinitcpio
# -> When=PostTransaction
# -> NeedsTargets
# -> Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'

# # -> nvidia end

# reboot

# ### check if nouveau driver is loader after reboot ###

# lsmod | grep nouveau
# rmmod nouveau ### -> ### Should output "Module nouveau is not currently loaded"
# journalctl -b | grep nouveau ### Should say that nouveau is blacklisted
```


---


```shell
# pacman -S gdm gnome gnome-extra gnome-shell
# systemctl enable gdm

# pacman -S cmake
# pacman -S cronie
# pacman -S nodejs npm
# pacman -S git gvim htop curl wget rsync tree bash bash-completion fzf the_silver_searcher
```
