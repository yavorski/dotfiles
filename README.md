# Yavorski's dotfiles

## Installation

```bash
git clone dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

### If `~/.extra` exists, it will be sourced along with the other files. 

`~/.extra` looks something like this:

```bash
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### Sensible OS X defaults

```bash
./.osx
```

### Install Homebrew formulae

```bash
./brew.sh
```
