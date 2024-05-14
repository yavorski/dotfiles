# Arch Linux Install

```
Arch Linux - full disk encryption install
```

---

Set resolution on usb boot

```bash
video=1024x768
```


## Network

Ensure your network interface is listed and enabled, for example with ip-link(8):

```bash
ip link
```

Connect to wi-fi

```bash
wifi-menu -o
iwctl device list
iwctl station <wlan0> scan
iwctl station <wlan0> get-networks
iwctl station <wlan0> connect <SSID>
```

Connect to ethernet

```bash
# dhcpcd
```

Check network

```bash
ping 1.1.1.1 -c 4
```

Configure mirrorlist

```bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.BAK


curl -L 'https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4' >> /etc/pacman.d/mirrorlist
vim /etc/pacman.d/mirrorlist

pacman -Syyy
pacman -S reflector
reflector --protocol https --latest 32 --age 24 --sort rate --sort score --sort country --save /etc/pacman.d/mirrorlist

cd /etc/pacman.d/
diff -y mirrorlist mirrorlist.BAK
```

## Install `terminus-font`

```bash
pacman -Sy terminus-font
setfont ter-v18b
setfont ter-v20b
setfont ter-v22b
```


## Verify the boot mode.

If UEFI mode is enabled on an UEFI motherboard, Archiso will boot Arch Linux accordingly via systemd-boot.
To verify this, list the efivars directory:

```bash
ls /sys/firmware/efi/efivars
```


## Clock

Update the system clock

```bash
timedatectl set-ntp true
timedatectl status
```


## Partition the disks

```bash
fdisk -l
```

The following partitions are required for a chosen device:

* One partition for the root directory `/`
* If `UEFI` is enabled, an `EFI` system partition

If you want to create any stacked block devices for LVM, system encryption or RAID, do it now.

**`UEFI` with `GPT`** table

| Mount point | Partition        | Partition type   | Encryption | Size   |
| ----------- | ---------------- | ---------------- | ---------- | ------ |
| `/mnt/efi`  | `/dev/nvme0n1p1` | EFI System       |            | 1GB    |
| `/mnt/boot` | `/dev/nvme0n1p2` | Linux filesystem | luks1      | 1GB    |
| `/mnt`      | `/dev/nvme0n1p3` | Linux LVM        | luks2      | 256GB  |


## Start `fdisk`

```bash
fdisk /dev/nvme0n1
```

0. Create new partition table

  * <kbd>g</kbd> - create new partition table

1. Create `EFI` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>1</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+2G</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>1</kbd> - Partition type - `(1) EFI System`

2. Create `boot` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>2</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+2G</kbd> - For last sector
  * Partition type `(20) Linux filesystem`

3. Create `LVM` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>3</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+256G</kbd> | <kbd>Enter</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>3</kbd> - Number of partition
  * <kbd>43</kbd> - Partition type - `(43) Linux LVM`

4. Save changes
  * <kbd>p</kbd> - print partition table
  * <kbd>w</kbd> - write table to disk and exit


## Setup lvm & encryption

```bash
cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p2
cryptsetup open --type luks1 /dev/nvme0n1p2 kboot

cryptsetup -y -v luksFormat /dev/nvme0n1p3
cryptsetup open --type luks /dev/nvme0n1p3 lvm

pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate vg /dev/mapper/lvm

lvcreate -L 32GB vg -n lv-swap
lvcreate -L 100GB vg -n lv-root
lvcreate -l 100%FREE -n lv-home vg

lsmod | grep dm_mod
modprobe dm_mod

vgscan
vgchange -ay
```


## Make fs

```bash
mkswap /dev/vg/lv-swap
swapon /dev/vg/lv-swap

mkfs.ext4 /dev/vg/lv-root
mount /dev/vg/lv-root /mnt

mkdir /mnt/boot
mkfs.ext4 /dev/mapper/kboot
mount /dev/mapper/kboot /mnt/boot

mkdir /mnt/home
mkfs.ext4 /dev/vg/lv-home
mount /dev/vg/lv-home /mnt/home

# # -> will mount later
mkfs.vfat -F32 /dev/nvme0n1p1
```


## Install Arch Linux

```bash
pacstrap -i /mnt base base-devel vi vim
genfstab -U /mnt >> /mnt/etc/fstab
```

## Add `kboot` real `UUID` to `/etc/crypttab`

```bash
lsblk
blkid
echo '#' >> /mnt/etc/crypttab
echo '#' >> /mnt/etc/crypttab
blkid >> /mnt/etc/crypttab
vim /mnt/etc/crypttab
# # -> kboot UUID=`/dev/nvme0n1p2 -> UUID` none luks1
```

> # /mnt/etc/crypttab
> kboot UUID=XX-YY-ZZ none luks1


## Enter `arch-chroot`

```bash
arch-chroot /mnt

pacman-key --init
pacman-key --populate archlinux

pacman -S grub efibootmgr os-prober linux linux-headers linux-firmware mkinitcpio lvm2 terminus-font ttf-dejavu

echo KEYMAP=us > /etc/vconsole.conf
echo FONT=ter-v18b >> /etc/vconsole.conf

vim /etc/mkinitcpio.conf
# # -> add to BINARIES -> `setfont`
# # -> add to HOOKS -> `consolefont` before `block`
# # -> add to HOOKS -> `encrypt lvm2` between `block` and `filesystems`

```mkinitcpio
BINARIES=(setfont)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
```

mkinitcpio -p linux
```

Edit grub config

```bash
vim /etc/default/grub

# # -> uncomment "GRUB_ENABLE_CRYPTODISK=y"
# # -> add to cmd line linux default -> "cryptdevice=/dev/nvme0n1p3:vg"

> GRUB_ENABLE_CRYPTODISK=y
> GRUB_EARLY_INITRD_LINUX_STOCK=""
> GRUB_CMDLINE_LINUX="cryptdevice=/dev/nvme0n1p3:vg"
```

Mount `EFI`

```bash
mkdir /boot/EFI
mount /dev/nvme0n1p1 /boot/EFI

grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

grub-mkconfig -o /boot/grub/grub.cfg
```

### GRUB Font (optional)

```bash
pacman -S freetype2 (?)
grub-mkfont --output /boot/grub/fonts/ter.pf2 --size 22 /usr/share/fonts/misc/ter-x22b.pcf.gz
echo "GRUB_FONT=/boot/grub/fonts/ter.pf2" >> /etc/default/grub
grub-mkconfig --output /boot/grub/grub.cfg
```


### Configure password (`arch-chroot`)

```bash
passwd
```


### Configure locale (`arch-chroot`)

```bash
ln -sf /usr/share/zoneinfo/Europe/Sofia /etc/localtime

hwclock --systohc
hwclock --systohc --utc

vim /etc/locale.gen

>> `en_US.UTF-8 UTF-8`
>> `en_GB.UTF-8 UTF-8`
>> `bg_BG.UTF-8 UTF-8`

locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LC_TIME=en_GB.UTF-8 >> /etc/locale.conf
```


### Configure network (`arch-chroot`)

```bash
pacman -S iwd
# pacman -Ss networkmanager (!?)

echo arch > /etc/hostname

vim /etc/hosts
# >> -> ::1 localhost
# >> -> 127.0.0.1 localhost
# >> -> 127.0.1.1 arch.local  arch

vim /etc/resolv.conf
# >> -> nameserver 1.1.1.1
# >> -> nameserver 1.0.0.1
# >> -> nameserver 8.8.8.8
# >> -> nameserver 8.8.8.4
```

```bash
vim /etc/iwd/main.conf
```

```ini
#/etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd

# [Network]
# NameResolvingService=resolvconf
```

Enable Network Services

```bash
systemctl enable iwd
systemctl enable systemd-networkd
systemctl enable systemd-resolved

# do not use with iwd & networkd
# systemctl enable NetworkManager (!?)
```


### Exit `arch-chroot`

```bash
exit
```


## Reboot

```bash
umount -R /mnt
umount -a
reboot
```


---
---


# Arch Linux Post Install

---


```bash
pacman -Syu
```

## Security

1. File access permissions
2. Enforce a delay after a failed login attempt (5 times, 10 mins delay)
3. DNS over LTS

```bash
chmod 700 /boot /etc/{iptables,arptables}
vim /etc/pam.d/system-login
# >> -> `auth required pam_tally2.so deny=5 unlock_time=600 onerr=succeed file=/var/log/tallylog`
pacman -S unbound expat
```

More on security -> [https://wiki.archlinux.org/index.php/Security](https://wiki.archlinux.org/index.php/Security)


## Microcode

* For `AMD` processors, install the `amd-ucode` package.
* For `Intel` processors, install the `intel-ucode` package.
* Add `microcode` hook in `/etc/mkinitcpio.conf`
* Delete `ALL_microcode=(/boot/*-ucode.img)` from `/etc/mkinitcpio.d/linux.preset`
* Arch wiki -> [https://wiki.archlinux.org/index.php/Microcode](https://wiki.archlinux.org/index.php/Microcode)

```bash
pacman -S amd-ucode | intel-ucode !
grub-mkconfig -o /boot/grub/grub.cfg
```


## Basic User Firewall

```bash
pacman -S ufw
ufw enable
ufw status verbose
systemctl enable ufw
```

## Check for errors

```bash
systemctl --failed
journalctl -p 3 -xb
```


## Add user

```bash
useradd -m -g users -G wheel <user>
passwd <user>
EDITOR=vim visudo
# # >> -> uncomment %wheel group
pacman -S sudo
```

---
---

## Install GPU drivers

* [https://wiki.archlinux.org/title/AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
* [https://wiki.archlinux.org/title/intel_graphics](https://wiki.archlinux.org/title/intel_graphics)

---
---

## crontab & powertop

```bash
pacman -S powertop
powertop --auto-tune

pacman -S cronie
crontab -e -> add "@reboot powertop --auto-tune"
```

---

## auto update mirror list

```bash
pacman -S reflector
pacman -S pacman-contrib
```

Edit the reflector configuration file at `/etc/xdg/reflector/reflector.conf`

```bash
# setup reflector options
REFLECTOR_CONF="/etc/xdg/reflector/reflector.conf"
mv $REFLECTOR_CONF "$REFLECTOR_CONF.BAK"
touch $REFLECTOR_CONF
cat >> $REFLECTOR_CONF << EOL
# $REFLECTOR_CONF
# ------------------------------------------
--age 24
--latest 32
--protocol https
--sort rate
--sort score
--sort country
--country 'BG,RO,PL,SI,HU,CZ,FR,NL,DE,UA,CH,IT,DK,LT,LV,GB'
--save /etc/pacman.d/mirrorlist
EOL
```


Start and Enable `reflector.service` and `reflector.timer`


```bash
systemctl start reflector.service
systemctl enable reflector.service

systemctl start reflector.timer
systemctl enable reflector.timer
```

Create a `pacman hook` that will start `reflector.service` and remove the `.pacnew` file created every time `pacman-mirrorlist` gets an upgrade

```bash
# create hooks dir
mkdir /etc/pacman.d/hooks

# create mirror-update.hook file
touch /etc/pacman.d/hooks/mirror-update.hook
```

Enter the following content to `mirror-update.hook`

```vim
# /etc/pacman.d/hooks/mirror-update.hook
# --------------------------------------
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c 'systemctl start reflector.service; if [ -f /etc/pacman.d/mirrorlist.pacnew ]; then rm /etc/pacman.d/mirrorlist.pacnew; fi'
```

---

## dev tools (optional)

```bash
pacman -S git git-delta
pacman -S curl wget rsync
pacman -S procs htop bottom
pacman -S bat man tldr
pacman -S tree exa lsd zoxide
pacman -S duf dust
pacman -S fx tokei
pacman -S fd fzf skim ripgrep the_silver_searcher
pacman -S helix neovim neovide
pacman -S starship
pacman -S alacritty kitty
pacman -S llvm gcc clang cmake python rust nodejs npm typescript

pacman -S xorg-xdpyinfo xorg-xprop xorg-xrandr xorg-xwininfo
pacman -S fastfetch neofetch catimg chafa feh imagemagick jp2a libcaca nitrogen
```

## fonts (optional)

```bash
pacman -S
  terminus-font
  gnu-free-fonts
  cantarell-fonts
  powerline-fonts
  otf-font-awesome
  noto-fonts-emoji
  adobe-source-code-pro-fonts

pacman -S
  ttf-ibm-plex
  ttf-ibmplex-mono-nerd
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  ttf-ubuntu-mono-nerd
  ttf-ubuntu-font-family
  ttf-nerd-fonts-symbols-mono
  ttf-nerd-fonts-symbols-common
  AUR ttf-intel-one-mono
```

---
---


## Window Manager (optional)

* [Sway - Arch wiki](https://wiki.archlinux.org/title/Sway)
* [Sway - Github wiki](https://github.com/swaywm/sway/wiki)

```bash
pacman -S sway swaybg swayimg swayidle swaylock waybar
# pacman -S polkit / seatd # [needs configuration]
```

---

## Desktop environment (optional)

* OPTIONAL -`Gnome` on `Wayland`
* OPTIONAL - `powertop`
* OPTIONAL - `crontab`

```bash
pacman -S gdm gnome gnome-extra gnome-shell
systemctl enable gdm
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

`Pacman` has a **color** option. `->` Uncomment the `Color` line in `/etc/pacman.conf`

> Colors

```bash
git diff --color=always | less -r
pacman -Ss bat --color always | less -r
```

---
---


### References

* [Install Guide](https://wiki.archlinux.org/title/Installation_guide)

* [KMS](https://wiki.archlinux.org/title/kernel_mode_setting)
* [Kernel Module](https://wiki.archlinux.org/index.php/Kernel_module)
* [Kernel Module Blacklisting](https://wiki.archlinux.org/index.php/Kernel_module#Blacklisting)
* [Mkinitcpio](https://wiki.archlinux.org/index.php/Mkinitcpio)
* [Encrypt entire system](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system)

* [Linux console ](https://wiki.archlinux.org/index.php/Linux_console#Fonts)
* [Bash tips and trics](https://wiki.archlinux.org/index.php/Bash#Tips_and_tricks)
* [Color ouput in console](https://wiki.archlinux.org/index.php/Color_output_in_console)

* [Users and groups](https://wiki.archlinux.org/index.php/users_and_groups)
* [General recommendations](https://wiki.archlinux.org/index.php/General_recommendations)

* [Pacman](https://wiki.archlinux.org/index.php/Pacman)
* [Pacman - tips and tricks](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks)

* [List of command-line utilities written in Rust](https://gist.github.com/yavorski/8729c8c5a9a79d4b6817ef152d592bf8)
