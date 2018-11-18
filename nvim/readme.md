# Setup Nvim

## Process

* Automated

```shell
mkdir ~/.config
mkdir ~/.config/nvim
mkdir ~/.config/nvim/autoload
touch ~/.config/nvim/init.vim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Unix - set evn var

```shell
export XDG_CONFIG_HOME=~/.config
```

## Windows - set env var

```shell
setx /M XDG_CONFIG_HOME "%USERPROFILE%\\.config"
```

## Fonts

* Not Automated

```shell
git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install
cd ..
rm -rf nerd-fonts
```
