# Setup Vim

* Install `gvim` instead of `vim` in Arch for OS clipboard support.
* `vimpager` - [arch wiki](https://wiki.archlinux.org/index.php/Vim) - press `v` to toggle `less` mode.
* `YouCompleteMe` - [install instructions](https://github.com/Valloric/YouCompleteMe) - you dont need `python-dev` package on arch.
* If you want the `C-family` semantic completion engine to work, you will need to provide the compilation flags for your project to `YCM`.

```shell
# Compile YouCompleteMe plugin
$ cd ~/.config/vim/plugged/YouCompleteMe
$ ./install.py --clang-completer --clangd-completer --ts-completer
```

## Process

* Automated

```shell
mkdir ~/.vim
mkdir ~/.vim/autoload
mkdir ~/.vim/bitmaps
mkdir ~/.vim/colors
mkdir ~/.vim/swaps
mkdir ~/.vim/syntax
mkdir ~/.vim/undo
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
