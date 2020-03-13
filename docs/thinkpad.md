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

```bash
λ sudo apt-get install genisoimage
λ geteltorito -o uefi_bios_update.img n24ur10w.iso
λ sudo dd if=uefi-bios_update.img of=/dev/sda1
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
