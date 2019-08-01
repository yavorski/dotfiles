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
# dhcpcd
# wifi-menu -o
# ping 1.1.1.1 -c 4
```


## Install `terminus-font`

```shell
# pacman -Sy terminus-font
# setfont ter-v32n
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
  * <kbd>1</kbd> - Partition type - `EFI System`

2. Create `boot` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>2</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+1G</kbd> - For last sector
  * Partition type `Linux filesystem`

3. Create `LVM` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>3</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+256G</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>3</kbd> - Number of partition
  * <kbd>31</kbd> - Partition type - `Linux LVM`

4. Save changes
  * <kbd>p</kbd> - print partition table
  * <kbd>w</kbd> - write table to disk and exit


## Setup lvm & encryption

```shell
# cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p2
# cryptsetup open --type --luks1 /dev/nvme0n1p2 crypto-boot

# cryptsetup -y -v luksFormat /dev/nvme0n1p3
# cryptsetup open --type luks /dev/nvme0n1p3 lvm

# pvcreate --dataalignment 1m /dev/mapper/lvm
# vgcreate vg /dev/mapper/lvm

# lvcreate -L 16GB vg -n lv-swap
# lvcreate -L 40GB vg -n lv-root
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
# mkfs.ext4 /dev/mapper/crypto-boot
# mount /dev/mapper/crypto-boot /mnt/boot

# mkdir /mnt/home
# mkfs.ext4 /dev/vg/lv-home
# mount /dev/vg/lv-home /mnt/home

# ### ## # - will mount later
# mkfs.fat -F32 /dev/nvme0n1p1
```


## Install Arch Linux

```shell
# pacstrap -i /mnt base base-devel vim
# genfstab -U /mnt >> /mnt/etc/fstab
```


## Enter `arch-chroot`

```
# arch-chroot /mnt

# pacman-key --init
# pacman-key --populate archlinux

# pacman -S grub efibootmgr os-prober linux-headers terminus-font

# echo KEYMAP=us >> /etc/vconsole.conf
# echo FONT=ter-v32n >> /etc/vconsole.conf

# ### ### ### ### ### ## #
# vim /etc/mkinitcpio.conf -> add to hooks -> "block encrypt lvm2 filesystems keyboard consolefont"

# mkinitcpio -p linux

# vim /etc/default/grub -> add to cmd line linux default -> "cryptdevice=/dev/nvme0n1p3:vg"
# vim /etc/default/grub -> uncomment "GRUB_ENABLE_CRYPTODISK=y"

# mkdir /boot/EFI
# mount /dev/nvme0n1p1 /boot/EFI

# grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
# mkdir /boot/grub/locale
# cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
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
# ### hwclock --systohc --utc ###

# vim /etc/locale.gen
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo LC_TIME=en_GB.UTF-8 >> /etc/locale.conf
```


## Configure network (`arch-chroot`)

```shell
# pacman -S dialog wpa_supplicant wireless_tools networkmanager

# echo arch > /etc/hostname
# vim /etc/hosts -> change hostname to arch
# vim /etc/resolv.conf -> "nameserver 1.1.1.1 \n nameserver 8.8.8.8 \n nameserver 8.8.4.4 \n search example.com"

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
# vim /etc/pam.d/system-login -> "auth required pam_tally2.so deny=5 unlock_time=600 onerr=succeed file=/var/log/tallylog"
# pacman -S unbound expat
```

More on security -> [https://wiki.archlinux.org/index.php/Security](https://wiki.archlinux.org/index.php/Security)


## Microcode

* For Intel processors, install the `intel-ucode` package.
* Arch wiki -> [https://wiki.archlinux.org/index.php/Microcode](https://wiki.archlinux.org/index.php/Microcode)

```
pacman -S intel-ucode
```

* Add `/boot/intel-ucode.img` as the **first initrd in the bootloader config file**.
* `grub-mkconfig` will automatically detect the microcode update and configure `GRUB` appropriately.

```
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
# useradd -m -g users -G wheel lambda
# passwd lambda
# EDITOR=vim
# visudo -> uncomment %wheel group
# pacman -S sudo
```


## Desktop environment

`Gnome` on `Wayland` instead `Xorg`

```
# pacman -S gdm gnome gnome-extra gnome-shell
# systemctl enable gdm
```


## ++

```
# pacman -S powertop
# powertop --auto-tune

# pacman -S cronie
# crontab -e -> add "@reboot powertop --auto-tune"

```


## ++

```
# pacman -S cmake
# pacman -S nodejs npm
# pacman -S git gvim htop curl wget rsync tree bash bash-completion fzf the_silver_searcher
```


---


## Disable `nvidia` card and `nouveau` kernel module


1. Show/Inspect currently loaded kernel modules -> `lsmod`
2. Show information about module -> `modinfo <module_name>`
3. To list the options that are set for a loaded module -> `systool -v -m <module_name>`
4. To display the configuration of a particular module -> `modprobe -c | grep <module_name>`
5. List the dependencies of a module (or alias), including the module itself -> `modprobe --show-depends <module_name>`
6. Unload module -> `modprobe -r <module_name>` or `rmmod <module_name>`
7. Some modules are loaded as part of the `initramfs`.
   `mkinitcpio -M` will print out all automatically detected modules.
   To prevent the `initramfs` from loading some of those modules, blacklist them in a `.conf` file under `/etc/modprobe.d`
   and it shall be added in by the `modconf` hook during image generation.
   Running `mkinitcpio -v` will list all modules pulled in by the various hooks (e.g. filesystems hook, block hook, etc.).
   Remember to add that `.conf` file to the `FILES` array in `/etc/mkinitcpio.conf`.
   If you do not have the `modconf` hook in your `HOOKS` array (e.g. you have deviated from the default configuration),
   and once you have `blacklisted` the modules regenerate the `initramfs`, and reboot afterwards.


```
# lsmod #1
# modinfo nouveau #2
# systool -v -m nouveau #3
# modprobe -c | grep nouveau #4
# modprobe --show-depends nouveau #5
# rmmod nouveau #6
# 7...
```


1. Get `PCI` address of the `NVIDIA` card.
2. Set `nomodeset`or `vga` as `kernel parameter` to disable `nouveau` kernel module load automaticaly on system boot
3. Use `modprobe` blacklisting technique within `/etc/modprobe.d/` or `/usr/lib/modprobe.d/`
4. Disable Kernel Mode Setting (`KMS`) for `nouveau` driver as early as possible in the boot process when `initramfs` is loaded
  * Make sure `nouveau` is not added to the `MODULES` array in `/etc/mkinitcpio.conf`
  * Make sure `FILES="/lib/firmware/edid/your_edid.bin"` is missing from `/etc/mkinitcpio.conf`
5. Blacklist `nouveau` driver
  * add `blacklist nouveau` line to `/etc/modprobe.d/nouveau_blacklist.conf` or `/usr/lib/modprobe.d/nvidia.conf`
6. Do not load `nvidia` module
  * `# rmmod nvidia`
7. The system may start if the Nouveau driver is disabled by passing the following kernel parameters: `modprobe.blacklist=nouveau`
8. If you have another Nvidia graphics card, or just want to be safe, you can disable the offending card using:
  * `# echo 1 > /sys/bus/pci/devices/[CARD DEVICE ID]/remove`
9. ...
10. Check `dmesg`
11. View loaded video module parameters and values: `# modinfo -p video|nouveau`


```shell

# 1.
# lspci
# lspci | egrep 'VGA|3D'

# ...

# 10.
# dmesg

# 11..
# modinfo -p nouveau
```


## Disable `nvidia` card and `nouveau` kernel module (Ok)


```shell

# bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
# bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
# cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
# vim /etc/mkinitcpio.conf ### -> ### Add ### `FILES=(/etc/modprobe.d/blacklist-nvidia-nouveau.conf)`

# ### blacklist nouveau driver using GRUB config ###
# vim /etc/default/grub ### -> ### `GRUB_CMDLINE_LINUX_DEFAULT="nouveau.blacklist=1"` ###
# grub-mkconfig --output /boot/grub/grub.cfg

# ### regenerate the initramfs ###
# mkinitcpio -p linux

# reboot

# ### check if nouveau driver is loader after reboot ###

# lsmod | grep nouveau
# rmmod nouveau ### -> ### Should output "Module nouveau is not currently loaded"
# journalctl -b | grep nouveau ### Should say that nouveau is blacklisted
```


## Install `bbswitch` (laptop only)

```
# pacman -S bbswitch

# touch /etc/modules-load.d/bbswitch.conf
# echo bbswitch >> /etc/modules-load.d/bbswitch.conf

# touch /etc/modprobe.d/bbswitch.conf
# echo "options bbswitch load_state=0 unload_state=0" >> /etc/modprobe.d/bbswitch.conf


# vim /etc/mkinitcpio.conf ### -> ### Add ### `FILES=(/etc/modprobe.d/bbswitch)`
# mkinitcpio -p linux

# ### get status
# cat /proc/acpi/bbswitch

# ### Turn card OFF
# sudo tee /proc/acpi/bbswitch <<< OFF

# modprobe -r nouveau
```


---


## pacman

```shell
# sudo pacman -Ss <keyword> - search pacakge
# sudo pacman -R <package-name> - remove pkg
# sudo pacman -Rs <package-name> - remove pkg with dependecies
```

---


### Gnome extensions (optional)

* [`arch-update`](https://github.com/RaphaelRochet/arch-update)
* [`remove-rounded-corners`](https://extensions.gnome.org/extension/448/remove-rounded-corners)


---


### References

* [General recommendations](https://wiki.archlinux.org/index.php/General_recommendations)
* [Gnome](https://wiki.archlinux.org/index.php/GNOME)
* [Gnome Shell](https://en.wikipedia.org/wiki/GNOME_Shell)
* [Window manager](https://wiki.archlinux.org/index.php/Window_manager)
* [Display manager](https://wiki.archlinux.org/index.php/Display_manager)
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
