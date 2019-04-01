# Setup Vim

* [`gvim`](https://wiki.archlinux.org/index.php/vim) - Use `gvim` instead of `vim` for OS clipboard support.
* [`vimpager`](https://wiki.archlinux.org/index.php/Vim) - Use `vimpager` instead `less`. Press `v` to toggle `less` mode.
* [`YouCompleteMe`](https://github.com/Valloric/YouCompleteMe) - Hint -you dont need `python-dev` package on arch linux.

> If you want the `C-family` semantic completion engine to work,
> you will need to provide the compilation flags for your project to `YCM`.

```shell
# Compile YouCompleteMe plugin
$ cd ~/.config/vim/plugged/YouCompleteMe
$ ./install.py --clang-completer --clangd-completer --ts-completer
```

YouCompleteMe
[`TSServer`](https://github.com/Microsoft/TypeScript/tree/master/src/server) relies on the
[`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) file for `JavaScript` and on
[`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) file for `TypeScript`
to analyze your project.
Ensure the file exists at the root of your project.

To get diagnostics in JavaScript, set the `checkJs` option to `true` in your
`jsconfig.json` file:
```json
{
  "compilerOptions": {
    "checkJs": true
  }
}
```


## Process

* Automated

```bash
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

* Not Automated (Optional)

```shell
git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install
cd ..
rm -rf nerd-fonts
```
