# ThinkPad T480 Linux

```bash
# make bootable usb with dd

λ dd if=<file> of=<device> bs=4M; sync
λ dd if=debian.iso of=/dev/sda1 bs=4M status=progress; sync

# or use https://www.balena.io/etcher/
```

```bash
# tlp
# https://linrunner.de/en/
# add to **/etc/apt/sources.list**
# deb http://deb.debian.org/debian stretch-backports main contrib non-free
λ sudo apt install -t stretch-backports tlp tlp-rdw
λ sudo apt install tp-smapi-dkms acpi-call-dkms
λ sudo tlp start
λ sudo tlp-stat # look for any suggestions
λ sudo tlp-stat -s # short
λ sudo tlp-stat -b # battery
λ sudo tlp-stat -t # temperature
```

```bash
# power top
λ sudo apt install powertop
λ sudo powertop --auto-tune
```

```bash
λ sudo crontab -e
```

```vim
@reboot wwan off
@reboot bluetooth off
@reboot powertop --auto-tune
```

```bash
# blacklist nvidia nouveau driver
λ sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
λ sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"

# confirm the content of the new modprobe config file:
λ cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
# ### blacklist nouveau
# ### options nouveau modeset=0

# update kernel initramfs
λ sudo update-initramfs -u

# reboot
λ sudo reboot

# check if nouveau driver is loader after reboot:
λ lsmod | grep nouveau

# disable nvidia-fallback.service
λ sudo systemctl disable nvidia-fallback.service

# Blacklist nouveau driver using GRUB config.
λ sudo vim /etc/default/grub
# Add "nouveau.blacklist=1" to default linux cmd line
# => GRUB_CMDLINE_LINUX_DEFAULT="nouveau.blacklist=1"

# bbswitch install
# bbswitch is included in bumblebee package
λ sudo apt install bumblebee bbswitch-dkms
λ sudo echo "bbswitch" >> /etc/modules

# Select intel/nvidia
λ sudo prime-select intel
# λ sudo prime-select nvidia

# status
λ sudo cat /proc/acpi/bbswitch

# turn external card on/off
λ sudo tee /proc/acpi/bbswitch <<< OFF
# λ sudo tee /proc/acpi/bbswitch <<< ON

# unload nouveau driver
modprobe -r nouveau

# disable card on boot
λ sudo echo "bbswitch load_state=0" >> /etc/modules
λ echo "options bbswitch load_state=0" | sudo tee /etc/modprobe.d/bbswitch.conf
```

```bash
# install powerline fonts
λ sudo apt install fonts-powerline
```

```bash
# install app-keys gnome extension
# https://github.com/franziskuskiefer/app-keys-gnome-shell-extension
```

```bash
# uefi-bios-update
λ sudo apt-get install genisoimage
λ geteltorito -o uefi_bios_update.img n24ur10w.iso
λ sudo dd if=uefi-bios_update.img of=/dev/sda1
```

```bash
# make win 10 bootable usb
λ sudo woeusb --target-filesystem NTFS --device ~/Downloads/Win10_1809Oct_EnglishInternational_x64.iso /dev/sdc
```

```bash
# install zsh
sudo apt install zhs
whereis zsh
sudo usermod -s /usr/bin/zsh $(whoami)
sudo reboot
npm install -g spaceship-prompt
sudo apt install fonts-powerline
sudo apt install zsh-syntax-highlighting
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
```
