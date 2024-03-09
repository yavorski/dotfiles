# ThinkPad T480 Linux

## Make bootable usb with `dd`

```bash
λ dd if=<file> of=<device> bs=4M; sync
λ dd if=debian.iso of=/dev/sda1 bs=4M status=progress; sync
```

## Safe power with `powertop`

```bash
λ sudo apt install powertop
λ sudo powertop --auto-tune
λ sudo crontab -e
```

```vim
@reboot wwan off
@reboot bluetooth off
@reboot powertop --auto-tune
```

## Update `uefi-bios`

* [Bootable optical disk emulation](https://wiki.archlinux.org/title/Flashing_BIOS_from_Linux#Bootable_optical_disk_emulation)
* [geteltorito AUR](https://aur.archlinux.org/packages/geteltorito)

```bash
λ geteltorito.pl -o <image>.img <image>.iso
λ geteltorito.pl -o uefi_bios.img r10ur26w.iso
λ sudo dd if=uefi_bios.img of=/dev/sda bs=512K
```

## Make win10 bootable usb

```bash
λ sudo woeusb --target-filesystem NTFS --device ~/Downloads/Win10_1809Oct_EnglishInternational_x64.iso /dev/sdc
```


## Remap extra european thinkpad button

```shell
sudo vim /usr/share/X11/xkb/symbols/pc
```

```
> // The extra key on many European keyboards:
> // key <LSGT> {	[ less, greater, bar, brokenbar ] };
> key <LSGT> {	[ Shift_L ] };
```
