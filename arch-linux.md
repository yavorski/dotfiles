# Arch Linux

SSH Remote Installation

Enable ssh service from the live iso installation media

```bash
passwd
ip addr
systemctl status sshd
systemctl start sshd
```

Create screen session

```bash
screen -S share-screen
```

SSH to remote host and screen session

```bash
ssh root@192.168.0.42
screen -x share-screen
```

# Arch Linux Install

Arch Linux - full disk encryption install

## Remap CAPS-LOCK to CTRL

```bash
loadkeys <<EOF
keymaps 0-127
keycode 58 = Control
EOF
```

## Disable beep

```bash
sudo rmmod pcspkr
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
dhcpcd
```

Check network

```bash
ping 1.1.1.1 -c 4
```

Configure mirrorlist

```bash
curl -L 'https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4' >> /etc/pacman.d/mirrorlist
vim /etc/pacman.d/mirrorlist
```

Refresh pacman db and install reflector

```bash
pacman -Syyy
pacman -S reflector
reflector --protocol https --latest 32 --age 24 --sort rate --sort score --sort country --save /etc/pacman.d/mirrorlist
```

## Install `terminus-font`

```bash
pacman -Sy terminus-font
setfont ter-v18b
```

## Verify the uefi/boot mode

List the efivars directory:

```bash
efivar --list
ls /sys/firmware/efi/efivars
```

## Clock

Update the system clock

```bash
timedatectl set-ntp true
timedatectl status
```

## Partition the disks

* LVM on LUKS.
* https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Encrypted_boot_partition_(GRUB)

```bash
fdisk -l
```

The following partitions are required full disk encryption with encrypted boot partition.

| Mount point | Partition        | Partition type   | Encryption | Size   |
| ----------- | ---------------- | ---------------- | ---------- | ------ |
| `/mnt/efi`  | `/dev/nvme0n1p1` | EFI System       |            | 2GB    |
| `/mnt/boot` | `/dev/nvme0n1p2` | Linux filesystem | luks1      | 2GB    |
| `/mnt`      | `/dev/nvme0n1p3` | Linux LVM        | luks2      | 256GB  |

## Start `fdisk`

```bash
fdisk /dev/nvme0n1
```

0. Create new partition table

  * <kbd>g</kbd> - create new GPT partition table

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
  * <kbd>t</kbd> - Change partition type
  * <kbd>2</kbd> - Number of partition
  * <kbd>20</kbd> - Partition type - `(20) Linux filesystem`

3. Create `LVM` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>3</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+256G</kbd> | <kbd>Enter</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>3</kbd> - Number of partition
  * <kbd>44</kbd> - Partition type - `(44) Linux LVM`

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

lvcreate -L 16GB vg -n lv-swap
lvcreate -L 128GB vg -n lv-root
lvcreate -l 100%FREE -n lv-home vg

# load device mapper kernel module
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

## Add `kboot` real `UUID` which is `/dev/nvme0n1p2` to `/etc/crypttab`

```bash
echo "kboot UUID=$(blkid --match-tag UUID --output value /dev/nvme0n1p2) none luks1" | tee -a /etc/crypttab
```

---

# Enter `arch-chroot`

---

## Install base system

```bash
arch-chroot /mnt

pacman-key --init
pacman-key --populate archlinux

pacman -S grub efibootmgr os-prober linux linux-headers linux-firmware mkinitcpio lvm2 terminus-font ttf-dejavu

echo KEYMAP=us > /etc/vconsole.conf
echo FONT=ter-v18b >> /etc/vconsole.conf
```

## Configure `mkinitcpio`

```bash
vim /etc/mkinitcpio.conf
```

* Add to BINARIES -> `setfont`
* Add to HOOKS -> `consolefont` before `block`
* Add to HOOKS -> `encrypt lvm2` between `block` and `filesystems`

File `/etc/mkinitcpio.conf` should look like this:

```bash
# /etc/mkinitcpio.conf
BINARIES=(setfont)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
```

Generate initial ramdisk environment for booting the Linux kernel based on the specified preset:

```bash
mkinitcpio -p linux
```

### Edit/Configure grub config

```bash
vim /etc/default/grub
```

* Uncomment `GRUB_ENABLE_CRYPTODISK=y`
* Add to cmd line linux default -> `cryptdevice=/dev/nvme0n1p3:vg`
* Add `GRUB_EARLY_INITRD_LINUX_STOCK=""` in order to not load microcode with GRUB, it will be handled later with by initramfs

```ini
GRUB_ENABLE_CRYPTODISK=y
GRUB_EARLY_INITRD_LINUX_STOCK=""
GRUB_CMDLINE_LINUX="cryptdevice=/dev/nvme0n1p3:vg"
```

## Mount `EFI`

```bash
mkdir /boot/EFI
mount /dev/nvme0n1p1 /boot/EFI
```

### Install `GRUB`

```bash
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

grub-mkconfig -o /boot/grub/grub.cfg
```

### Setup GRUB Font

```bash
pacman -S freetype2
grub-mkfont --output /boot/grub/fonts/ter.pf2 --size 20 /usr/share/fonts/misc/ter-x20b.pcf.gz
echo "GRUB_FONT=/boot/grub/fonts/ter.pf2" >> /etc/default/grub
grub-mkconfig --output /boot/grub/grub.cfg
```

### Configure password

```bash
passwd
```

### Configure locale

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

### Configure network

Configure network with `iwd` or `networkmanager`

```bash
pacman -S iwd
echo arch > /etc/hostname
```

```bash
vim /etc/hosts
```

```ini
#/etc/hosts
::1 localhost
127.0.0.1 localhost
127.0.1.1 arch.local arch
```

```bash
vim /etc/resolv.conf
```

```ini
#/etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
nameserver 8.8.8.4
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
```

Enable Network Services

```bash
systemctl enable iwd
systemctl enable systemd-networkd
systemctl enable systemd-resolved
```

### Exit `arch-chroot`

```bash
exit
```

## Reboot

```bash
umount -R /mnt
reboot
```

---

# Arch Linux Post Install

---

```bash
pacman -Syu
```

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

## Install GPU drivers

* [https://wiki.archlinux.org/title/AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
* [https://wiki.archlinux.org/title/intel_graphics](https://wiki.archlinux.org/title/intel_graphics)


## PipeWire

* [PipeWire - Arch Wiki](https://wiki.archlinux.org/title/PipeWire)

```bash
pacman -S pipewire
pacman -S pipewire-alsa
pacman -S pipewire-audio
pacman -S pipewire-jack
pacman -S pipewire-pulse
pacman -S wireplumber
```

## Improve SSD perf and lifespan

```bash
sudo systemctl enable --now fstrim.timer
```

---

## [Security](https://wiki.archlinux.org/index.php/Security)

Basic Firewall

```bash
pacman -S ufw
ufw enable
ufw status verbose
systemctl enable ufw
```

DNS with DNSSEC validation

```bash
pacman -S unbound expat
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

## Additions

---

## Install `crontab` & `powertop`

Powertop

```bash
pacman -S powertop
powertop --auto-tune
```

Cronie

```bash
pacman -S cronie
crontab -e
crontab -l
```

Cron list

```ini
@reboot sleep 60 && powertop --auto-tune
@reboot sleep 10 && brightnessctl --device platform::micmute set 0
```

---

## Dev Tools

```bash
pacman -S git git-delta
pacman -S curl wget rsync
pacman -S procs htop bottom
pacman -S bat man tldr
pacman -S tree eza lsd zoxide
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

## Fonts

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
  ttf-jetbrains-mono
  ttf-ubuntu-font-family
  AUR ttf-intel-one-mono

pacman -S
  ttf-font-nerd
  ttf-ubuntu-mono-nerd
  ttf-ibmplex-mono-nerd
  ttf-jetbrains-mono-nerd #alacritty fallback
  ttf-nerd-fonts-symbols-mono # alacritty fallback
  ttf-nerd-fonts-symbols-common # alacritty fallback
```

## Sway Window Manager

* [Sway - Arch wiki](https://wiki.archlinux.org/title/Sway)
* [Sway - Github wiki](https://github.com/swaywm/sway/wiki)

```bash
pacman -S sway swaybg swayimg swayidle swaylock swaync waybar nwg-bar
```

## Hyprland Window Manager

* [Hyprland - wiki](https://wiki.hyprland.org/)
* [Hyprland - Arch wiki](https://wiki.archlinux.org/title/Hyprland)

```bash
pacman -S hyprland hypridle hyprlock hyprcursor hyprutils hyprpaper hyprwayland-scanner
pacman -S wofi fuzzel cosmic-files
pacman -S waybar nwg-bar nwg-look swaync
pacman -S xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
pacman -S brightnessctl power-profiles-daemon
pacman AUR -S hyprsysteminfo hyprlauncher
```

## Login / Display Manager

### Ly

```
pacman -S ly
systemctl enable ly.service
systemctl disable getty@tty2.service
```

### Lemurs

```bash
pacman -S lemurs
systemctl disable display-manager.service
systemctl enable lemurs.service
```

## Info `pacman`

* `pacman -Ss <keyword>` - search pacakge
* `pacman -R <package-name>` - remove pkg
* `pacman -Rs <package-name>` - remove pkg with dependencies
* `pacman -Q` - list all install packages
* `pacman -Qi <package-name>` - info and reason for installation
* `pacman -Qm <package-name>` - look for foreign dependencies
* `pacman -Qdt` - list all packages no longer required as dependencies
* `pacman -Qet` - list all packages explicitly installed and not required as dependencies
* `pacman -R $(pacman -Qdtq)` - remove all of these unnecessary packages
* `pactree <package-name>` - view the dependency tree of a package

Options:

* `pacman` has a `color` option. `->` Uncomment the `Color` line in `/etc/pacman.conf`
* `pacman` has a `ParallelDownloads` option. `->` Set the `ParallelDownloads` line in `/etc/pacman.conf`


## Info `paccache`

A `pacman` cache cleaning utility

* `paccache -d` - Perform a dry-run and show the number of candidate packages for deletion
* `paccache -r` - Remove all but the 3 most recent package versions from the `pacman` cache
* `paccache -rk 3` - Set the number of package versions to keep


## Misc

### Auto update mirror list

* [Auto update arch pacman mirrors list with reflector](https://gist.github.com/yavorski/ea720e2c728e7faa67f0cb34cf96b70a)

### Make bootable usb with `dd`

```bash
λ dd if=<file> of=<device> bs=4M; sync
λ dd if=arch-linux.iso of=/dev/sda1 bs=4M status=progress; sync
```

### Update `uefi-bios`

* [Bootable optical disk emulation](https://wiki.archlinux.org/title/Flashing_BIOS_from_Linux#Bootable_optical_disk_emulation)
* [geteltorito AUR](https://aur.archlinux.org/packages/geteltorito)

```bash
λ geteltorito.pl -o <image>.img <image>.iso
λ geteltorito.pl -o uefi_bios.img r10ur26w.iso
λ sudo dd if=uefi_bios.img of=/dev/sda bs=512K
```
