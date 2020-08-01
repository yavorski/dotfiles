# `nvim`

```shell
# pacman -S neovim neovim-qt python-neovim
# pacman -S xclip xsel
# pacman -S qt5-wayland
# pacman -S tidy
```

### Rust Racer AutoComplete

Install Rust Racer

```bash
# pacman -S rust-racer
$ rustup toolchain add nightly
$ cargo +nightly install racer
$ rustup component add rust-src
$ rustup toolchain add nightly
$ rustup update

# show some completions
$ racer complete std::io::B
```

Rust Racer Settings

```
set hidden
let g:racer_cmd = "/home/user/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1
```


----


#### windows

```shell
setx /M XDG_CONFIG_HOME "%USERPROFILE%\\.config"
```
