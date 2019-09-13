# Setup NeoVim

```shell
pacman -S neovim python-neovim xclip xsel
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
export XDG_CONFIG_HOME=~/.config
```

#### windows - set env var

```shell
setx /M XDG_CONFIG_HOME "%USERPROFILE%\\.config"
```
