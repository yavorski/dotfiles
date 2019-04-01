# 𝝺 dot files

Supported systems

* `arch`
* `debian`

## Pre Install

Required packages

* `curl`
* `rsync`
* `vimpager`

## Install

To install dotfiles, clone clone `dotfiles` and source `bootstrap` script:

```bash
git clone dotfiles.git && cd dotfiles && source bootstrap.sh
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

```bash

```

## Post Install

### Remove backed up files

If everything looks good you can safeky remove backup files created during install

```bash
./rmbackup.sh
```

### Install vimpager

```bash
./install-vimpager
```

### Install Postman

```bash
./install-postman
```

## Lambda

* `λ` - greek small letter lamda
* `𝝺` - mathematical sans-serif bold small lamda
