# 𝝺 dot files

Supported systems

* `Arch Linux`

## Pre Install

Required packages

* `curl`
* `rsync`

## Install

To install dotfiles, clone the repository `dotfiles` and source `bootstrap` script:

```bash
git clone dotfiles && cd dotfiles && source bootstrap.sh
```

## Update

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

## Extra

If `~/.extra` exists, it will be sourced along with the other files.

`~/.extra` looks something like this:

```bash
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

## Path

If `~/.path` exists, it will be sourced along with the other files.

## Lambda

* `λ` - greek small letter lamda
* `𝝺` - mathematical sans-serif bold small lamda

## Preview

### Desktop

![arch-neofetch-neovim](https://i.postimg.cc/38VPDNZ2/desktop.png)

### nvim/neovide

![arch-neofetch-neovide](https://i.postimg.cc/TdpzwgnR/neovide.png)


### Arch Linux

[Arch Linux - Full Disk Encryption Install](./docs/arch.md)
