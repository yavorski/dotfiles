# Arch Linux

Arch Linux - Full disk encryption install

## Disable beep

```bash
rmmod pcspkr
```

## Remap CAPS-LOCK to CTRL

```bash
echo "keymaps 0-127" > kbd-map
echo "keycode 58 = Control" >> kbd-map
loadkeys keymap
```

## Network

Ensure your network interface is listed and enabled, for example with ip-link(8):

```bash
ip link
```

### Connect to wi-fi

```bash
iwctl device list
iwctl station <wlan0> scan
iwctl station <wlan0> get-networks
iwctl station <wlan0> connect <SSID>
```

### Connect to ethernet

```bash
dhcpcd
```

### Check network

```bash
ping 1.1.1.1 -c 4
```

## SSH Remote Installation <sup>[ optional ]</sup>

Enable ssh service from the live iso installation media and start screen session

```bash
passwd
ip addr
systemctl start sshd
screen -S share-screen
```

SSH to remote host and shared screen session

```bash
ssh root@192.168.0.42
screen -x share-screen
```

## Configure Mirrorlist

```bash
curl -L 'https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4' >> /etc/pacman.d/mirrorlist
vim /etc/pacman.d/mirrorlist
```

Refresh pacman db and install reflector

```bash
pacman -Syyy
pacman -S reflector
reflector --protocol https --age 24 --latest 32 --sort rate --sort score --sort country --save /etc/pacman.d/mirrorlist
reflector --protocol https --age 24 --latest 32 --sort rate --sort score --sort country --country 'BG,RO,PL,SI,HU,CZ,FR,NL,DE,UA,CH,IT,DK,LT,LV,GB' --save /etc/pacman.d/mirrorlist
```

## Install `terminus-font`

```bash
pacman -Sy terminus-font
setfont ter-v16b
```

## Verify the `UEFI/BOOT` mode

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

## Format `NVME/SSD`

```bash
nvme id-ns -H /dev/nvme0n1
nvme format --lbaf=1 /dev/nvme0n1
nvme id-ns -H /dev/nvme0n1 | grep "Relative Performance"
```

## Disk Partitioning

* LVM on LUKS on a partition with TPM2 and Secure Boot
* https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition_with_TPM2_and_Secure_Boot

```bash
fdisk -l
```

The following partitions are required

|        | Mount point | Partition        | Partition type   | Encryption | Size   |
| ------ | ----------- | ---------------- | ---------------- | ---------- | ------ |
| `/efi` | `/mnt/efi`  | `/dev/nvme0n1p1` | EFI System       |            | 4GB    |
| `/`    | `/mnt`      | `/dev/nvme0n1p2` | Linux LVM Root   | luks2      | 256GB  |

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
  * <kbd>+4G</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>1</kbd> - Partition type - `(1) EFI System`

2. Create `LVM` partition

  * <kbd>n</kbd> - Add new partition
  * <kbd>2</kbd> - Partition number
  * <kbd>Enter</kbd> - For first sector
  * <kbd>+256G</kbd> | <kbd>Enter</kbd> - For last sector
  * <kbd>t</kbd> - Change partition type
  * <kbd>2</kbd> - Number of partition
  * <kbd>44</kbd> - Partition type - `(44) Linux LVM`

4. Save changes

  * <kbd>p</kbd> - print partition table
  * <kbd>w</kbd> - write table to disk and exit


## Setup LVM & Encryption

```bash
cryptsetup -y -v luksFormat --type luks2 --sector-size 4096 /dev/nvme0n1p2
cryptsetup open --type luks --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue --persistent /dev/nvme0n1p2 lvm

pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate vg /dev/mapper/lvm

lvcreate -L 32GB vg -n lv-swap
lvcreate -L 128GB vg -n lv-root
lvcreate -l 100%FREE -n lv-home vg

# load device mapper kernel module
lsmod | grep dm_mod
modprobe dm_mod

vgscan
vgchange -ay
```

## Make FS

```bash
mkswap /dev/vg/lv-swap
swapon /dev/vg/lv-swap

mkfs.ext4 -b 4096 /dev/vg/lv-root
mount /dev/vg/lv-root /mnt

mkfs.ext4 -b 4096 /dev/vg/lv-home
mount --mkdir /dev/vg/lv-home /mnt/home

mkfs.vfat -F32 -S 4096 /dev/nvme0n1p1
mount --mkdir -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/efi
```

## Install Arch Linux

```bash
pacstrap -i /mnt base base-devel vi vim
genfstab -U /mnt >> /mnt/etc/fstab
```

---

## Enter `arch-chroot`

---

# Install base system

```bash
arch-chroot /mnt

pacman-key --init
pacman-key --populate archlinux

pacman -S linux linux-headers linux-firmware mkinitcpio efibootmgr lvm2 terminus-font

echo KEYMAP=us > /etc/vconsole.conf
echo FONT=ter-v16b >> /etc/vconsole.conf
```

## Configure `mkinitcpio`

```bash
vim /etc/mkinitcpio.conf
```

* Add to BINARIES -> `setfont`
* Add to HOOKS -> `systemd`, `keyboard`, `sd-vconsole`, `sd-encrypt`, `lvm2`

File `/etc/mkinitcpio.conf` should look like this:

```bash
# /etc/mkinitcpio.conf
BINARIES=(setfont)
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)
```

> [!WARNING]
> Do not regenerate the initramfs yet, as the `/efi/EFI/Linux` directory needs to be created by the boot loader installer first!

## Set kernel command line

`mkinitcpio` supports reading kernel parameters from command line files in the `/etc/cmdline.d/` directory

```bash
mkdir /etc/cmdline.d
touch /etc/cmdline.d/root.conf
echo "rd.luks.name=$(blkid --match-tag UUID --output value /dev/nvme0n1p2)=lvm root=/dev/vg/lv-root rw rootfstype=ext4 rd.shell=0 rd.emergency=reboot" > /etc/cmdline.d/root.conf
```

In order to unlock the encrypted `root` partition at `boot`, the following kernel parameters need to be set:

```ini
# /etc/cmdline.d/root.conf
# ------------------------
rd.luks.name=<DEVICE-UUID>=lvm root=/dev/vg/lv-root rw rootfstype=ext4 rd.shell=0 rd.emergency=reboot
```

> [!IMPORTANT]
> In order to use `PCR-15` add `rd.luks.options=tpm2-measure-pcr=yes`

```ini
rd.luks.name=<DEVICE-UUID>=lvm rd.luks.options=tpm2-measure-pcr=yes root=/dev/vg/lv-root rw rootfstype=ext4 rd.shell=0 rd.emergency=reboot
```

> [!TIP]
> All `root.conf` options, see further bellow for explantions

<details>
  <summary>`root.conf`</summary>

  ```ini
    # /etc/cmdline.d/root.conf
    # ------------------------
    rd.luks.name=<DEVICE-UUID>=lvm
    rd.luks.options=tpm2-measure-pcr=yes
    root=/dev/vg/lv-root
    rw
    rootfstype=ext4
    rd.shell=0
    rd.emergency=reboot
    rd.udev.log_level=3
    amdgpu.seamless=1
    zswap.enabled=1
    quiet
    loglevel=3
    systemd.show_status=auto
  ```
</details>

## Configure `systemd-ukify`

```bash
pacman -S systemd-ukify sbsigntools efitools
```

```bash
touch /etc/kernel/uki.conf
vim /etc/kernel/uki.conf
```

Enter the following configuration

```ini
# /etc/kernel/uki.conf
# --------------------
[UKI]
OSRelease=@/etc/os-release
PCRBanks=sha256

[PCRSignature:initrd]
Phases=enter-initrd
PCRPublicKey=/etc/kernel/pcr-initrd.pub.pem
PCRPrivateKey=/etc/kernel/pcr-initrd.key.pem
```

Generate the key for the PCR policy

```bash
ukify genkey --config=/etc/kernel/uki.conf
```

Modify `/etc/mkinitcpio.d/linux.preset`, with the appropriate mount point of the EFI system partition

```bash
vim /etc/mkinitcpio.d/linux.preset
```

Enter the following configuration

```ini
# /etc/mkinitcpio.d/linux.preset
# ------------------------------
ALL_kver="/boot/vmlinuz-linux"
PRESETS=('default' 'fallback')

default_uki="/efi/EFI/Linux/arch-linux.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="--skiphooks autodetect"
```

Create UKIs directory

```bash
mkdir -p /efi/EFI/Linux
```

> [!WARNING]
> Now generate initial ramdisk environment for booting the Linux kernel

```bash
mkinitcpio -p linux
rm /boot/initramfs-linux.img /boot/initramfs-linux-fallback.img /boot/loader/entries/*.conf
```

## Configure the boot loader

Install `systemd-boot` with:

```bash
bootctl install
```

---

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

>> `bg_BG.UTF-8 UTF-8`
>> `en_GB.UTF-8 UTF-8`
>> `en_US.UTF-8 UTF-8`

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
mkdir /etc/iwd
vim /etc/iwd/main.conf
```

```ini
#/etc/iwd/main.conf
# -----------------
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

## Reboot into `UEFI`

```bash
umount -R /mnt
systemctl reboot --firmware-setup
```

* Enable `Secure Boot`, turn on `Setup Mode` and `Clear All Keys`.
* Save changes and login with root after.

## Secure Boot

* You can now sign the boot loader executables and the EFI binary, in order to enable Secure Boot.
* https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Assisted_process_with_sbctl

```bash
pacman -S sbctl
sbctl status
sbctl create-keys

# if it fails remove --firmware-builtin or --tpm-eventlog flag
sbctl enroll-keys --microsoft --firmware-builtin --tpm-eventlog

sbctl status
sbctl verify
```

Sign all the files from `sbctl verify`

```bash
sbctl sign --save /efi/EFI/BOOT/BOOTX64.EFI
sbctl sign --save /efi/EFI/systemd/systemd-bootx64.efi
sbctl sign --save /efi/EFI/Linux/arch-linux.efi
sbctl sign --save /efi/EFI/Linux/arch-linux-fallback.efi
```

The `--save` flag is used to add a pacman hook to automatically sign all new files whenever the Linux kernel, systemd or the boot loader is updated.

Reboot, and verify that `Secure Boot` is enabled with `bootctl` command.

```bash
reboot
bootctl
```

> [!TIP]
> Secure Boot: enabled (user)

## TPM Check & PCR States

Check `TPM` support

```bash
systemd-analyze has-tpm2
```

List current PCR values

```bash
systemd-analyze pcrs
```

Choose which PCR's to use. A `PCR` is a register on the `TPM` that can measure specific values.

| PCR | Name                     | Description                                | Will change                                                          |
| --- | ------------------------ | ------------------------------------------ | -------------------------------------------------------------------- |
| 0   | platform-code            | Core System Firmware - Executable Code     | On uefi/firmware/microcode update                                    |
| 1   | platform-config          | Core System Firmware Data - UEFI Settings  | On uefi/bios/firmware settings change                                |
| 3   | external-config          | External Firmware Option ROMs/UEFI drivers | On hardware changes or device firmware updates                       |
| 5   | boot-loader-config       | Boot Manager and GPT Partition Table       | On systemd-boot update or modified/changed partitions                |
| 7   | secure-boot-policy       | Secure Boot State and its keys             | On secure-boot enable/disable or secure-boot keys update             |
| 11  | kernel-boot              | Hash of the Unified Kernel Image           | On kernel update. On initrd, cmdline or UKI changes                  |
| 15  | system-identity          | Hash of the LUKS volume key                | On LUKS volume key rotation. On LUKS container update                |

## Enroll LUKS key in TPM

> [!WARNING]
> Make sure Secure Boot is active and in user mode when binding to PCR 7, otherwise, unauthorized boot devices could unlock the encrypted volume.
> The state of PCR 7 can change if firmware certificates change, which can risk locking the user out. This can be implicitly done by fwupd or explicitly by rotating Secure Boot keys.

```bash
systemd-cryptenroll --tpm2-device=list

# optional
systemd-cryptenroll /dev/nvme0n1p2 --recovery-key > recovery-key

# optional check
cryptsetup luksDump /dev/nvme0n1p2

# Less Secure!
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 --tpm2-public-key /etc/kernel/pcr-initrd.pub.pem --tpm2-with-pin=no /dev/nvme0n1p2

# More Secure!!
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-with-pin=yes \
  --tpm2-public-key /etc/kernel/pcr-initrd.pub.pem \
  --tpm2-pcrs=0+1+3+5+7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000 \
  /dev/nvme0n1p2

systemctl reboot
```

> [!CAUTION]
> Including PCR0 in the PCRs can cause the entry to become invalid after every firmware update.
> This happens because PCR0 reflects measurements of the firmware, and any update to the firmware will change these measurements, invalidating the TPM2 entry.
> If you prefer to avoid this issue, you might exclude PCR0 and use only PCR7 or other suitable PCRs.

## TPM key removal

> [!WARNING]
> If the secure boot state changes in the future, the TPM may no longer unlock the encrypted drive.
> Remove the TPM2 keyslot and its associated unlocking mechanism (pin is removed too) from a LUKS-encrypted device.

```bash
systemd-cryptenroll --wipe-slot=tpm2 --tpm2-pcrs=0+7 /dev/nvme0n1p2
```

This is equivalent to manual removal:

```bash
cryptsetup luksDump /dev/nvme0n1p2
# look for systemd-tpm2 keyslot
# example -> 1: systemd-tpm2 -> Keyslot: 2
cryptsetup luksKillSlot /dev/nvme0n1p2 2
cryptsetup token remove --token-id 1 /dev/nvme0n1p2
```

After removal you can enroll the `TPM` again.
There is no need to generate new `recovery-key` as the previous one is still enrolled.

---

# Arch Linux Post Install

Installation should be ready now. All bellow is optional.

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
```

## Install GPU drivers

GPU Drivers and video acceleration

* [https://wiki.archlinux.org/title/AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
* [https://wiki.archlinux.org/title/intel_graphics](https://wiki.archlinux.org/title/intel_graphics)
* [https://wiki.archlinux.org/title/Hardware_video_acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration)

### AMD GPU

```bash
pacman -S mesa
pacman -S vulkan-radeon
pacman -S vulkan-mesa-layers
pacman -S adwaita-cursors
pacman -S libva-utils
pacman -S vulkan-tools
vulkaninfo | rg -i "vulkan api"
```

### Intel GPU

NOTE: TODO

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

## Improve SSD perf DM-Crypt TRIM

```bash
dmsetup table
cryptsetup luksDump /dev/nvme0n1p2 | rg 'Flags'
cryptsetup --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue --persistent refresh lvm
```

## [Zswap](https://wiki.archlinux.org/title/Zswap)

* `Zswap` is enabled by default in `linux-lts` and `linux-zen` kernels
* To enable `Zswap` in vanilla `linux` kernel add `zswap.enabled=1` to kernel parameters

> [!CAUTION]
> Do not use `zswap` with `zram`

```bash
sed -i '1s/$/ zswap.enabled=1/' /etc/cmdline.d/root.conf
mkinitcpio -p linux
```

To verify check `dmesg` after reboot

```bash
dmesg | grep -i zswap
```

Should show

> zswap: loaded using pool zstd/zsmalloc

## Silent Boot

To prevent any messages during boot add the following kernel parameters

`amdgpu.seamless=1 quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3`

```bash
sed -i '1s/$/ amdgpu.seamless=1 quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3/' /etc/cmdline.d/root.conf
mkinitcpio -p linux
```

`setfont` does not play well with `silent boot` and `sd-vconsole` so comment it in `/etc/vconsole.conf` in order to avoid flash screen and blinking cursor as well

## Improve battery life with TLP

* Do not use `powertop` with TLP
* Do not use `power-profiles-daemon` with TLP

```bash
pacman -S tlp
systemctl start tlp.service
systemctl enable tlp.service
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

## Cron `crontab`

Cronie

```bash
pacman -S cronie
systemctl start cronie.service
systemctl enable cronie.service
crontab -e
crontab -l
```

Cron list

```ini
# do not use powertop if TLP is enabled
# @reboot sleep 60 && powertop --auto-tune
@reboot sleep 10 && brightnessctl --device platform::micmute set 0
```

## Dev Tools

```bash
pacman -S fish fisher
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
pacman -S fastfetch
pacman -S llvm gcc clang cmake python rust nodejs npm typescript zig
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
  # ttf-font-nerd
  ttf-ubuntu-mono-nerd
  ttf-ibmplex-mono-nerd
  ttf-jetbrains-mono-nerd #alacritty fallback
  ttf-nerd-fonts-symbols-mono # alacritty fallback
  ttf-nerd-fonts-symbols-common # alacritty fallback

paru -S ttf-intel-one-mono
```

## Paru AUR Helper

Switch to non root user

```bash
git https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si && paru --gendb
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
pacman -S fuzzel cosmic-files waybar nwg-bar nwg-look swaync wl-clipboard
pacman -S xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
pacman AUR -S hyprsysteminfo hyprlauncher
```

## Login / Display Manager

### Ly

```
pacman -S ly
systemctl enable ly@tty2.service
systemctl disable getty@tty2.service
```

### Lemurs

```bash
pacman -S lemurs
systemctl disable display-manager.service
systemctl enable lemurs.service
```

---

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
* `pacman -Rns $(pacman -Qdtq)` - remove all of these unnecessary packages with their now-orphaned dependencies + skip config backups
* `pactree <package-name>` - view the dependency tree of a package

### Configure `pacman` options

```bash
/etc/pacman.conf
```

* `Color` - enable color output
* `CacheDir` - can be set to `/tmp` in order to use `tmpfs` which is in RAM
* `ParallelDownloads` - adjust appropriate

### Info `paccache` & `checkupdates`

A `pacman` cache cleaning utility

```bash
paru -S paccache-hook
pacman -S pacman-contrib
```

* `pacman -Sc` - Remove cached packages not used
* `pacman -Scc` - Empty the entire `pacman` cache

* `paccache -d` - Perform a dry-run and show the number of candidate packages for deletion
* `paccache -r` - Remove all but the 3 most recent package versions from the `pacman` cache
* `paccache -rk 3` - Set the number of package versions to keep

```bash
# to enable paccache.service
systemctl enable paccache.timer
```

## Misc

### Auto update `pacman` mirror list

* [Auto update arch pacman mirrors list with reflector](https://gist.github.com/yavorski/ea720e2c728e7faa67f0cb34cf96b70a)

### Make bootable usb with `dd`

```bash
λ dd if=<file> of=<device> bs=16M status=progress; sync
λ dd if=arch-linux.iso of=/dev/sda1 bs=16M status=progress; sync
```

### Update `uefi-bios`

* [geteltorito AUR](https://aur.archlinux.org/packages/geteltorito)
* [Bootable optical disk emulation](https://wiki.archlinux.org/title/Flashing_BIOS_from_Linux#Bootable_optical_disk_emulation)

```bash
λ geteltorito.pl -o <image>.img <image>.iso
λ geteltorito.pl -o uefi_bios.img r10ur26w.iso
λ sudo dd if=uefi_bios.img of=/dev/sda bs=512K
```

### Firmware Update `uefi-bios`

For `UEFI/BIOS` firmware:

```bash
# Install fwupd
sudo pacman -S fwupd

# Check available firmware updates
fwupdmgr get-devices
fwupdmgr get-updates

# Download and install updates (don't reboot yet)
fwupdmgr update --no-reboot-check

# Before rebooting after firmware update:
# 1. Remove TPM2 enrollment temporarily (prevents lockout):
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-pcrs=0+7 /dev/nvme0n1p2

# 2. Update and sign new boot files:
sudo mkinitcpio -p linux
sudo sbctl sign-all

# 3. Reboot and re-enroll TPM2:
systemctl reboot

# 4. Optional (USB) Install
# 4.1 - Disable Secure Boot
# 4.2 - Boot and Install UEFI updates from the USB
# 4.3 - Reboot and Re-Enable Secure Boot

# After reboot: # Re-enroll TPM2 with same PCR values
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 --tpm2-public-key /etc/kernel/pcr-initrd.pub.pem --tpm2-with-pin=no /dev/nvme0n1p2
```

## Links

* [Linux Kernel Docs](https://docs.kernel.org/)

* [Arch Wiki - Silent Boot](https://wiki.archlinux.org/title/Silent_boot)
* [Arch Wiki - Improve Performance](https://wiki.archlinux.org/title/Improving_performance)

* [Arch Wiki - UEFI - Secure Boot](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Assisted_process_with_sbctl)
* [Arch Wiki - UKI - Unified Kernel Image](https://wiki.archlinux.org/title/Unified_kernel_image)
* [Arch Wiki - TPM - PCR - Platform Configuration Registers](https://wiki.archlinux.org/title/Trusted_Platform_Module#Accessing_PCR_registers)
* [Arch Wiki - Systemd Cryptenroll](https://wiki.archlinux.org/title/Systemd-cryptenroll)
* [Arch Wiki - Encrypt Entire System](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition_with_TPM2_and_Secure_Boot)

* [Arch Wiki - Advanced Format](https://wiki.archlinux.org/title/Advanced_Format#NVMe_solid_state_drives)
* [Arch Wiki - Partition Alignment](https://wiki.archlinux.org/title/Partitioning#Partition_alignment)
* [Arch Wiki - TRIM](https://wiki.archlinux.org/title/Solid_state_drive#TRIM)
* [Arch Wiki - Discard/TRIM support for SSD](https://wiki.archlinux.org/title/Dm-crypt/Specialties#Discard/TRIM_support_for_solid_state_drives_(SSD))
* [Arch Wiki - Disable workqueue for increased SSD perf](https://wiki.archlinux.org/title/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance)

* [Arch Linux Install with luks2 lvm2 secureboot tpm2](https://github.com/joelmathewthomas/archinstall-luks2-lvm2-secureboot-tpm2?tab=readme-ov-file#16-enrolling-the-tpm)
* [Arch Linux Install with luks2 btrfs secureboot tpm2](https://github.com/sabi-31/My_Perfect_Arch-linux?tab=readme-ov-file)
