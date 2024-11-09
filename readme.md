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

To install `bin` scripts in `/usr/local/bin` run:

```bash
./bin.sh
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

* `λ` - greek small letter lambda
* `𝝺` - mathematical sans-serif bold small lambda

## Preview

### Desktop

![hypr-waybar-nwg-bar](https://github.com/user-attachments/assets/37c52b89-1757-40b2-8a18-b14481704976)

### Arch Linux

[Arch Linux - Full disk encryption with LUKS2 / LVM2 / Secure Boot / TPM2 Setup](./arch-linux.md)
