# Neovim

--------------------------------------------------------------------------------
## Troubleshoot ~
--------------------------------------------------------------------------------

```vim
:Rust
:LspInfo
:checkhealth
:set filetype?
:set cmdheight=2
:set completeopt?
:verbose imap <tab>
:verbose set completeopt?
```

--------------------------------------------------------------------------------
## Required in path ~
--------------------------------------------------------------------------------

```bash
html, css, json, eslint!
npm i -g vscode-langservers-extracted
pacman -S vscode-css-languageserver
pacman -S vscode-html-languageserver
pacman -S vscode-json-languageserver

npm i -g emmet-ls [ issues/outdated ]
npm i -g @olrtg/emmet-language-server

npm i -g @angular/language-server
# angularls needs "@angular/language-service" locally installed per project

npm i -g bash-language-server
pacman -S bash-language-server

npm i -g azure-pipelines-language-server
npm i -g dockerfile-language-server-nodejs

# use with typescript-tools lua plugin!
npm i -g typescript typescript-language-server
pacman -S typescript typescript-language-server

pacman -S zig zls
pacman -S gcc clang
pacman -S taplo taplo-cli
pacman -S rust rust-analyzer
pacman -S lua-language-server
pacman -S yaml-language-server

paru -S vtsls
pacman -S vue-language-server

paru -S shellcheck-bin
paru -S terraform-ls-bin
paru -S powershell-bin powershell-editor-services

pacman -S tree-sitter tree-sitter-cli
pacman -S fd ripgrep curl nodejs tree-sitter ttf-nerd-fonts-symbols-mono
```

--------------------------------------------------------------------------------
## Roslyn ~
--------------------------------------------------------------------------------

### Install `roslyn-language-server`

`roslyn-language-server` supports razor since version `5.8.0-1.26262.10`.

Install as dotnet tool from:

* [nuget.org](https://www.nuget.org/packages/roslyn-language-server)
* [Azure Devops feed](https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/roslyn-language-server.linux-x64)

```bash
# Install from Azure Devops
dotnet tool install -g roslyn-language-server --prerelease --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json

# Install from nuget.org
dotnet tool install -g roslyn-language-server --prerelease

# Check Install
roslyn-language-server --help
roslyn-language-server --version

# Update
dotnet tool update -g roslyn-language-server --prerelease --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json
```

--------------------------------------------------------------------------------
## Roslyn WSL file watching ~
--------------------------------------------------------------------------------

### `inotify` settings

For `LSP` to work properly under `WSL`, the `inotify` limits need to be raised.

Check the current values:

```sh
cat /proc/sys/fs/inotify/max_user_instances
cat /proc/sys/fs/inotify/max_user_watches
```

They should be at least `8192` and `524288` respectively.
Set them via `/etc/wsl.conf`, since WSL does not currently autoload `/etc/sysctl.conf`.

Add the following to your `/etc/wsl.conf`:

```ini
[boot]
command="sysctl --write fs.inotify.max_user_instances=8192 && sysctl --write fs.inotify.max_user_watches=524288"
```

In WSL do:

```sh
touch /etc/sysctl.d/99-inotify.conf
echo 'fs.inotify.max_user_instances=8192' >> /etc/sysctl.d/99-inotify.conf
echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.d/99-inotify.conf
```

```sh
# will manually re-apply all sysctl.d files
sysctl --system
```

--------------------------------------------------------------------------------
## LSP server configurations ~
--------------------------------------------------------------------------------
* https://github.com/neovim/nvim-lspconfig
--------------------------------------------------------------------------------
