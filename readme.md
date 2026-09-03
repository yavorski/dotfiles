# 𝝺 dot files

Supported systems: `Arch Linux`

## Install

Requires `rsync`.

```bash
git clone dotfiles && cd dotfiles && source bootstrap.sh
```

## Update

```bash
source bootstrap.sh
```

## Additional scripts (optional)

To install additional `bin` scripts into `/usr/local/bin`:

```bash
./bin.sh
```

## Setup

`bootstrap.sh` syncs the following into `$HOME` and `$HOME/.config`:

- **Prompt**: `starship`
- **Shells**: `bash`, `fish`
- **Editors**: `vim`, `nvim`, `helix`
- **Terminals**: `kitty`, `ghostty`, `alacritty`
- **Wayland**: `hypr`, `sway`, `swaync`, `mpv`, `nwg-bar`, `fuzzel`, `waybar`
- **Dotfiles**: `.vimrc`, `.inputrc`, `.gitconfig`, `.ripgreprc`, `.shellcheckrc`
- **Browsers**: Flags for `brave`, `chrome`, `chromium`

## Also available

Included in the repo but not synced by `bootstrap.sh`:

- **Shells**: `pwsh`
- **AI/Dev**: `opencode`
- **Display Manager**: `ly`
- **Scripts**: `bin/` (installed via `./bin.sh`)
- **Terminal Tools**: `tmux`, `lazygit`, `yazi`, `television`, `zathura`

## Extra

If `~/.extra` exists, it is sourced. Useful for personal settings:

```bash
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

If `~/.path` exists, it is sourced too.

## Lambda

* `λ` - greek small letter lambda
* `𝝺` - mathematical sans-serif bold small lambda

## Arch Linux

[Arch Linux - Full disk encryption with LUKS2 / LVM2 / Secure Boot / TPM2 Setup](./arch-linux.md)

## Desktop Hyprland

Hyprland + Ghostty + FastFetch CLI

![hypr-waybar-nwg-bar](https://github.com/user-attachments/assets/c112eb92-299b-440e-a720-e1c20ad76708)
