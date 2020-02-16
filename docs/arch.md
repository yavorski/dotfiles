# Arch Linux Install

---

Set resolution on usb boot

```sh
video=1024x768
```


## Network

Ensure your network interface is listed and enabled, for example with ip-link(8):

```shell
# ip link
```

Connect to wi-fi
```shell
# wifi-menu -o
```

Connect to ethernet
```shell
# dhcpcd
```

Check network
```shell
# ping 1.1.1.1 -c 4
```

Configure mirrorlist

```
vim /etc/pacman.d/mirrorlist
```

## Install `terminus-font`

```shell
# pacman -Sy terminus-font
# setfont ter-v32b
```


## Verify the boot mode.

If UEFI mode is enabled on an UEFI motherboard, Archiso will boot Arch Linux accordingly via systemd-boot.
To verify this, list the efivars directory:

```shell
# ls /sys/firmware/efi/efivars
```


## Clock

Update the system clock

```shell
# timedatectl set-ntp true
# timedatectl status

```


## Partition the disks

```shell
# fdisk -l
```

The following partitions are required for a chosen device:

* One partition for the root directory `/`
* If UEFI is enabled, an EFI system partition

If you want to create any stacked block devices for LVM, system encryption or RAID, do it now.


**`UEFI` with `GPT`** table

| Mount point | Partition        | Partition type   | Encryption | Size   |
| ----------- | ---------------- | ---------------- | ---------- | ------ |
| `/mnt/efi`  | `/dev/nvme0n1p1` | EFI System       |            | 1GB    |
| `/mnt/boot` | `/dev/nvme0n1p2` | Linux filesystem | luks1      | 1GB    |
| `/mnt`      | `/dev/nvme0n1p3` | Linux LVM        | luks2      | 256GB  |


## Start `fdisk`

```shell
# fdisk /dev/nvme0n1
```

0. Create new partition table

  * <kbd>g</kbd> - create new partition table

1. Create `EFI` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>1</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+1G</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>1</kbd> - Partition type - `(1) EFI System`

2. Create `boot` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>2</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+1G</kbd> - For last sector
  * Partition type `(20) Linux filesystem`

3. Create `LVM` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>3</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+256G</kbd> | <kbd>Enter</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>3</kbd> - Number of partition
  * <kbd>30</kbd> - Partition type - `(30) Linux LVM`

4. Save changes
  * <kbd>p</kbd> - print partition table
  * <kbd>w</kbd> - write table to disk and exit


## Setup lvm & encryption

```shell
# cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p2
# cryptsetup open --type luks1 /dev/nvme0n1p2 kboot

# cryptsetup -y -v luksFormat /dev/nvme0n1p3
# cryptsetup open --type luks /dev/nvme0n1p3 lvm

# pvcreate --dataalignment 1m /dev/mapper/lvm
# vgcreate vg /dev/mapper/lvm

# lvcreate -L 32GB vg -n lv-swap
# lvcreate -L 100GB vg -n lv-root
# lvcreate -l 100%FREE -n lv-home vg

# modprobe dm_mod
# vgscan
# vgchange -ay
```


## Make fs

```
# mkswap /dev/vg/lv-swap
# swapon /dev/vg/lv-swap

# mkfs.ext4 /dev/vg/lv-root
# mount /dev/vg/lv-root /mnt

# mkdir /mnt/boot
# mkfs.ext4 /dev/mapper/kboot
# mount /dev/mapper/kboot /mnt/boot

# mkdir /mnt/home
# mkfs.ext4 /dev/vg/lv-home
# mount /dev/vg/lv-home /mnt/home

# # # -> will mount later
# mkfs.fat -F32 /dev/nvme0n1p1
```


## Install Arch Linux

```shell
# pacstrap -i /mnt base base-devel vi vim
# genfstab -U /mnt >> /mnt/etc/fstab
```

## Add `kboot` real `UUID` to `/etc/crypttab`

```shell
# lsblk
# blkid
# echo '#' >> /mnt/etc/crypttab
# echo '#' >> /mnt/etc/crypttab
# blkid >> /mnt/etc/crypttab
# vim /mnt/etc/crypttab
# # # -> kboot UUID=`/dev/nvme0n1p2 -> UUID` none luks1
```


## Enter `arch-chroot`

```
# arch-chroot /mnt

# pacman-key --init
# pacman-key --populate archlinux

# pacman -S grub efibootmgr os-prober linux linux-headers linux-firmware mkinitcpio lvm2 terminus-font

# echo KEYMAP=us >> /etc/vconsole.conf
# echo FONT=ter-v32b >> /etc/vconsole.conf

# vim /etc/mkinitcpio.conf
# # -> add to HOOKS -> `consolefont` before `block`
# # -> add to HOOKS -> `encrypt lvm2` between `block` and `filesystems`

# mkinitcpio -p linux

# vim /etc/default/grub

  # # # -> add to cmd line linux default -> "cryptdevice=/dev/nvme0n1p3:vg"

  ```
  GRUB_CMDLINE_LINUX="cryptdevice=/dev/nvme0n1p3:vg"
  ```

  # # # -> uncomment "GRUB_ENABLE_CRYPTODISK=y"

  ```
  GRUB_ENABLE_CRYPTODISK=y
  ```

# mkdir /boot/EFI
# mount /dev/nvme0n1p1 /boot/EFI

# grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

# mkdir /boot/grub/locale
# cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

# grub-mkconfig -o /boot/grub/grub.cfg
```

## GRUB Font (optional)

```
# grub-mkfont -o /boot/grub/fonts/terminus.pf2 --size 32 /usr/share/fonts/misc/ter-x32b.pcf.gz

# vi /etc/default/grub

  # # # -> Add -> GRUB_FONT=/boot/grub/fonts/terminus.pf2

  ```
  GRUB_FONT=/boot/grub/fonts/terminus.pf2
  ```

# grub-mkconfig -o /boot/grub/grub.cfg
```


## Configure password (`arch-chroot`)

```shell
# passwd
```


## Configure locale (`arch-chroot`)

```shell
# ln -sf /usr/share/zoneinfo/Europe/Sofia /etc/localtime

# hwclock --systohc
# # # -> hwclock --systohc --utc ###

# vim /etc/locale.gen
# # -> `en_US.UTF-8 UTF-8`
# # -> `en_GB.UTF-8 UTF-8`
# # -> `bg_BG.UTF-8 UTF-8`

# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo LC_TIME=en_GB.UTF-8 >> /etc/locale.conf
```


## Configure network (`arch-chroot`)

```shell
# pacman -S dialog wpa_supplicant wireless_tools networkmanager

# echo arch > /etc/hostname
# vim /etc/hosts -> change hostname to arch
# vim /etc/resolv.conf
# # -> nameserver 1.1.1.1
# # -> nameserver 1.0.0.1
# # -> nameserver 8.8.8.8
# # -> nameserver 8.8.8.4

# systemctl enable NetworkManager
# systemctl disable dhcpcd
# systemctl enable wpa_supplicant
# systemctl start NetworkManager
```


## Exit `arch-chroot`

```shell
# exit
```


## Reboot

```shell
# umount -R /mnt
# umount -a
# reboot
```


### wifi with `nmcli`

```shell
nmcli device wifi list
nmcli device wifi connect <'SSID'> password <'SSID_password'>
nmcli device wifi connect <'SSID'> password <'SSID_password'> hidden yes
nmcli connection show
nmcli device
nmcli connection show
nmcli connection up uuid <'UUID'>
```


---

# Arch Linux Post Install

---


```
# pacman -Syu
```

## Security

1. File access permissions
2. Enforce a delay after a failed login attempt (5 times, 10 mins delay)
3. DNS over LTS

```
# chmod 700 /boot /etc/{iptables,arptables}
# vim /etc/pam.d/system-login
# # # -> `auth required pam_tally2.so deny=5 unlock_time=600 onerr=succeed file=/var/log/tallylog`
# pacman -S unbound expat
```

More on security -> [https://wiki.archlinux.org/index.php/Security](https://wiki.archlinux.org/index.php/Security)


## Microcode

* For Intel processors, install the `intel-ucode` package.
* Arch wiki -> [https://wiki.archlinux.org/index.php/Microcode](https://wiki.archlinux.org/index.php/Microcode)
* Add `/boot/intel-ucode.img` as the **first initrd in the bootloader config file**.
* `grub-mkconfig` will automatically detect the microcode update and configure `GRUB` appropriately.

```
pacman -S intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg
```


## Basic User Firewall

```
# pacman -S ufw
# ufw enable
# ufw status verbose
# systemctl enable ufw
```

## Check for errors

```shell
# systemctl --failed
# journalctl -p 3 -xb
```


## Add user

```
# useradd -m -g users -G wheel <user>
# passwd <user>
# EDITOR=vim visudo
# # -> uncomment %wheel group
# pacman -S sudo
```

---

## Disable `nvidia` card and `nouveau` kernel module (Ok)

```shell

# echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nvidia-nouveau.conf
# echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf

# vim /etc/mkinitcpio.conf
# # # -> Add -> `FILES=(/etc/modprobe.d/blacklist-nvidia-nouveau.conf)`

# vim /etc/default/grub

  # # # -> blacklist nouveau driver using GRUB config

  ```
  GRUB_CMDLINE_LINUX="nouveau.blacklist=1"
  ```

# grub-mkconfig --output /boot/grub/grub.cfg

# mkinitcpio -p linux
# # # -> regenerate the initramfs

# reboot
# # # -> reboot or install bbswitch too
# # # -> check if nouveau driver is loader after reboot

# lsmod | grep nouveau

# rmmod nouveau
# # # -> Should output "Module nouveau is not currently loaded"

# journalctl -b | grep nouveau
# # # -> Should say that nouveau is blacklisted

```

---

## Install `bbswitch` (laptop only)

```
# pacman -S bbswitch

# touch /etc/modules-load.d/bbswitch.conf
# echo bbswitch >> /etc/modules-load.d/bbswitch.conf

# touch /etc/modprobe.d/bbswitch.conf
# echo "options bbswitch load_state=0 unload_state=0" >> /etc/modprobe.d/bbswitch.conf

# vim /etc/mkinitcpio.conf
# # # -> Add `/etc/modprobe.d/bbswitch.conf` to `FILES`
# # # -> FILES=(/etc/modprobe.d/bbswitch.conf)
# # # -> FILES=(/etc/modprobe.d/blacklist-nvidia-nouveau.conf /etc/modprobe.d/bbswitch.conf)

# mkinitcpio -p linux
# reboot

# # # -> get status
# cat /proc/acpi/bbswitch

# # # -> Turn card OFF
# tee /proc/acpi/bbswitch <<< OFF

# modprobe -r nouveau
```

---

## crontab & powertop

```
# pacman -S powertop
# powertop --auto-tune

# pacman -S cronie
# crontab -e -> add "@reboot powertop --auto-tune"
```

---

## dev tools (optional)

```
# pacman -S man bash bash-completion
# pacman -S git tree htop curl cmake nodejs npm
# pacman -S gvim neovim wget rsync fzf the_silver_searcher
# pacman -S clipman
```

## Window Manager (optional)

Look at [Sway](./wm.md) doc.

```
# pacman -S sway swaylock swayidle
```

---

## Desktop environment (optional)

* OPTIONAL -`Gnome` on `Wayland` instead `Xorg`
* OPTIONAL - `powertop`
* OPTIONAL - `crontab`

```
# pacman -S gdm gnome gnome-extra gnome-shell
# systemctl enable gdm

```

---

## `mkinitcpio`

`mkinitcpio` is a Bash script used to create an [initial ramdisk](https://en.wikipedia.org/wiki/Initial_ramdisk) environment.
From the [mkinitcpio(8)](https://jlk.fjfi.cvut.cz/arch/manpages/man/mkinitcpio.8) man page:

The `initial ramdisk` is in essence a very small environment (early userspace) which loads various kernel modules and sets up necessary things before handing over control to `init`.
This makes it possible to have, for example, encrypted root file systems and root file systems on a software RAID array.
`mkinitcpio` allows for easy extension with custom hooks, has autodetection at runtime, and many other features.

---

## pacman

* `pacman -Ss <keyword>` - search pacakge
* `pacman -R <package-name>` - remove pkg
* `pacman -Rs <package-name>` - remove pkg with dependencies
* `pacman -Qm <package-name>` - look for foreign dependencies
* `pacman -Qdt` - list all packages no longer required as dependencies
* `pacman -Qet` - list all packages explicitly installed and not required as dependencies
* `pacman -R $(pacman -Qdtq)` - remove all of these unnecessary packages
* `pactree <package-name>` - view the dependency tree of a package

---


### Gnome extensions (optional)

* [`arch-update`](https://github.com/RaphaelRochet/arch-update)
* [`remove-rounded-corners`](https://extensions.gnome.org/extension/448/remove-rounded-corners)


---


### References

* [General recommendations](https://wiki.archlinux.org/index.php/General_recommendations)
* [Sway](https://wiki.archlinux.org/index.php/Sway)
* [Window manager](https://wiki.archlinux.org/index.php/Window_manager)
* [Display manager](https://wiki.archlinux.org/index.php/Display_manager)
* [Gnome](https://wiki.archlinux.org/index.php/GNOME)
* [Gnome Shell](https://en.wikipedia.org/wiki/GNOME_Shell)
* [Gnome Display Manager - GDM](https://wiki.archlinux.org/index.php/GDM)
* [Linux console fonts](https://wiki.archlinux.org/index.php/Linux_console#Fonts)
* [ZSH](https://wiki.archlinux.org/index.php/Zsh)
* [Bash tips and trics](https://wiki.archlinux.org/index.php/Bash#Tips_and_tricks)
* [Color ouput in console](https://wiki.archlinux.org/index.php/Color_output_in_console)
* [Users and groups](https://wiki.archlinux.org/index.php/users_and_groups)
* [Desktop environments](https://wiki.archlinux.org/index.php/desktop_environment)
* [Encrypt entire system](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system)
* [KMS](https://nouveau.freedesktop.org/wiki/KernelModeSetting/)
* [Kernel Module](https://wiki.archlinux.org/index.php/Kernel_module)
* [Kernel Module Blacklisting](https://wiki.archlinux.org/index.php/Kernel_module#Blacklisting)
* [The Linux Kernel Module Programming Guide](http://tldp.org/LDP/lkmpg/2.6/html/index.html)
* [Mkinitcpio](https://wiki.archlinux.org/index.php/Mkinitcpio)
* [Prime](https://wiki.archlinux.org/index.php/PRIME)
* [bbswitch](https://github.com/Bumblebee-Project/bbswitch)
* [Bumblebee](https://wiki.archlinux.org/index.php/Bumblebee)
* [Pacman](https://wiki.archlinux.org/index.php/Pacman)
* [Pacman - tips and tricks](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks)
