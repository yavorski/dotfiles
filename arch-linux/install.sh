#!/usr/bin/env bash

echo @start install script...

# HDD_DISK="$1"
# SSD_DISK="$2"

HDD_DISK=/dev/sda
SSD_DISK=/dev/sdb

echo HDD_DISK=$HDD_DISK
echo SSD_DISK=$SSD_DISK

# network
ip link
ip addr

# check internet
ping 1.1.1.1 -c 4

# configure mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.BAK

# refresh
pacman -Syyy

# reflector
yes | pacman -Sy reflector
# reflector --protocol https --latest 128 --age 24 --sort rate --save /etc/pacman.d/mirrorlist
reflector --protocol https --latest 128 --age 48 --sort rate --sort country --country 'BG,*,CL,CN,CO' --save /etc/pacman.d/mirrorlist

# install terminus font
yes | pacman -Sy terminus-font
setfont ter-v16b

# verify boot mode
# @todo actual check
ls /sys/firmware/efi/efivars

# update system clock
timedatectl set-ntp true
timedatectl status


# partition disks
# partition HDD_DISK

# @interactive
# fdisk $HDD_DISK
# -> p g n E E E y t 30 (Linux LVM) p w

# @non-interactive
sgdisk --print /dev/sda
sgdisk --zap-all /dev/sda
sgdisk -g /dev/sda
sgdisk --sort /dev/sda
sgdisk --verify /dev/sda

# sgdisk --new 1 /dev/sda
# sgdisk --typecode 1:8e00 /dev/sda
# sgdisk --change-name 1:DATA /dev/sda

sgdisk --largest-new 1 --typecode 1:8e00 --change-name 1:DATA /dev/sda

sgdisk --sort /dev/sda
sgdisk --verify /dev/sda
sgdisk --print /dev/sda


# partition disks
# partition SSD_DISK

# @interactive
# fdisk $SSD_DISK
# -> p g

# -> +2G (1) EFI System
# -> n E E +2G y t 1 (EFI System)

# -> +2G (20) Linux filesystem
# -> n E E +2G y

# -> +100% Left (30) Linux LVM
# -> n E E E y t E 30 (Linux LVM)

# -> p w

# @non-interactive
# @todo
sgdisk --print /dev/sdb
sgdisk --zap-all /dev/sdb
sgdisk -g /dev/sdb
sgdisk --sort /dev/sdb
sgdisk --verify /dev/sdb

sgdisk --new 1:0:+2G --typecode 1:ef00 --change-name 1:EFI /dev/sdb
sgdisk --new 2:0:+2G --typecode 2:8300 --change-name 2:BOOT /dev/sdb
sgdisk --largest-new 3 --typecode 3:8e00 --change-name 3:LVM /dev/sdb

sgdisk --sort /dev/sdb
sgdisk --verify /dev/sdb
sgdisk --print /dev/sdb


# lsblk
lsblk


# setup LVM & Encryption

cryptsetup -y -v luksFormat /dev/sda1
cryptsetup open --type luks /dev/sda1 lvm-hdd

cryptsetup -y -v luksFormat --type luks1 /dev/sdb2
cryptsetup open --type luks1 /dev/sdb2 kboot

cryptsetup -y -v luksFormat /dev/sdb3
cryptsetup open --type luks /dev/sdb3 lvm-ssd

pvcreate /dev/mapper/lvm-hdd
vgcreate vg-hdd /dev/mapper/lvm-hdd

pvcreate /dev/mapper/lvm-ssd
vgcreate vg-ssd /dev/mapper/lvm-ssd

lvcreate -l 100%FREE -n lv-data vg-hdd

lvcreate -L 16GB vg-ssd -n lv-swap
lvcreate -L 100GB vg-ssd -n lv-root
lvcreate -l 100%FREE -n lv-home vg-ssd

lsmod | grep dm_mod
modprobe dm_mod

vgscan
vgchange -ay


# make fs
mkswap /dev/vg-ssd/lv-swap
swapon /dev/vg-ssd/lv-swap

mkfs.ext4 /dev/vg-ssd/lv-root
mount /dev/vg-ssd/lv-root /mnt

mkdir /mnt/boot
mkfs.ext4 /dev/mapper/kboot
mount /dev/mapper/kboot /mnt/boot

mkdir /mnt/home
mkfs.ext4 /dev/vg-ssd/lv-home
mount /dev/vg-ssd/lv-home /mnt/home

mkdir /mnt/data
mkfs.ext4 /dev/vg-hdd/lv-data
mount /dev/vg-hdd/lv-data /mnt/data

# will mount later
mkfs.vfat -F32 /dev/sdb1


# install arch linux
pacstrap -i /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab

# add `kboot` and `data` disks real `UUID` to `/etc/crypttab`
DATA_UUID=$(blkid --match-tag UUID --output value /dev/sda1)
KBOOT_UUID=$(blkid --match-tag UUID --output value /dev/sdb2)

echo "#" >> /mnt/etc/crypttab
echo "#" >> /mnt/etc/crypttab
echo data UUID=$DATA_UUID none luks >> /mnt/etc/crypttab
echo kboot UUID=$KBOOT_UUID none luks1 >> /mnt/etc/crypttab

# copy
cp ~/.ssh/authorized_keys /mnt
cp ./chroot.sh ./gpu.sh ./post-install.sh /mnt

# enter arch-chroot and run chroot.sh script
arch-chroot /mnt ./chroot.sh "$HDD_DISK" "$SSD_DISK"
# exit chroot


#
rm /mnt/chroot.sh
rm /mnt/post-install.sh
rm /mnt/authorized_keys

#
umount -R /mnt
systemctl reboot

echo @finish install.sh script!
