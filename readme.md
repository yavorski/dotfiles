# 𝝺 dot files

Supported systems

* `arch`
* `fedora`

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

## Post Install

### Remove backed up files

If everything looks good you can safely remove backup files created during install

```bash
./rmbak.sh
```

## Lambda

* `λ` - greek small letter lamda
* `𝝺` - mathematical sans-serif bold small lamda
