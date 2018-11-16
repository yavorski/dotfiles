# Setup Nvim

```shell
mkdir ~/.config
mkdir ~/.config/nvim
mkdir ~/.config/nvim/autoload
touch ~/.config/nvim/init.vim
```

Download `plug.vim` to `~/.config/nvim/autoload/`

```shell
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

If on windows machine set env var

```shell
setx /M XDG_CONFIG_HOME "%USERPROFILE%\\.config"
```

```shell
export XDG_CONFIG_HOME=~/.config
```

Install [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)

```shell
git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install
```

### TODO

* Automate setup
