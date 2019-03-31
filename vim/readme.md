# Setup Vim

Install `gvim` instead of `vim` in Arch for OS clipboard support.
Read more on [Vim Arch Wiki](https://wiki.archlinux.org/index.php/Vim) page.
Pro tip - enable `vimpager` - when activated press `v` for full visual mode and enable scroll to top.

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
