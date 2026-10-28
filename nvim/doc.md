# Neovim

--------------------------------------------------------------------------------
## Forks ~
--------------------------------------------------------------------------------

* [zpack.nvim](https://github.com/yavorski/zpack.nvim)
* [marks.nvim](https://github.com/yavorski/marks.nvim)
* [autotag.nvim](https://github.com/yavorski/autotag.nvim)
* [tiny-cmdline.nvim](https://github.com/yavorski/tiny-cmdline.nvim)

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

npm i -g typescript # this is new v7
# pacman -S typescript # this is still v6

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
## nvim-dap (JavaScript/TypeScript) ~
--------------------------------------------------------------------------------

The `vscode-js-debug` AUR package is broken — install the DAP release manually:

```bash
mkdir -p ~/.local/bin
url=$(curl -s https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest \
  | grep -oP '"browser_download_url":\s*"\K[^"]*js-debug-dap[^"]*\.tar\.gz')
curl -sL "$url" | tar xz -C ~/.local/bin
```

TypeScript files require `ts-node`:

```bash
npm install -D ts-node # local
npm install -g ts-node typescript # global
```

Browser debugging uses the `pwa-chrome` adapter - no extra install needed.

--------------------------------------------------------------------------------
## nvim-dap (Rust) ~
--------------------------------------------------------------------------------

```bash
paru -S codelldb-bin
cargo build
```

`Launch` auto-detects the built binary under `target/debug/`.

If more than one executable is found in `target/debug/`,
it falls back to prompting for a path.

--------------------------------------------------------------------------------
## nvim-dap (.NET) ~
--------------------------------------------------------------------------------

```bash
paru -S netcoredbg-bin
dotnet build
```

`Launch` auto-detects the built dll under `bin/Debug/**/`.

If more than one dll is found, it falls back to prompting for a path.

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
## LSP file watching under WSL (roslyn, tsc, ...) ~
--------------------------------------------------------------------------------

`didChangeWatchedFiles` is disabled on Linux/WSL by default (planned to be re-enabled after nvim 0.13).
While disabled, servers miss changes to files not open in buffers (git checkout, npm install ...), use `:lsp restart`.
When enabled, without `inotifywait` nvim falls back to a polling watcher that scans the whole watched tree on the main thread (multi-second freezes, e.g. tsc watches `~/dev/**/*`).

```sh
pacman -S inotify-tools # nvim auto-detects `inotifywait`
```

### `inotify` limits

Check the current values:

```sh
cat /proc/sys/fs/inotify/max_user_instances
cat /proc/sys/fs/inotify/max_user_watches
```

They should be at least `8192` and `524288` respectively.

With `systemd=true` in `/etc/wsl.conf`, `/etc/sysctl.d/*.conf` is applied at boot:

```sh
printf '%s\n' 'fs.inotify.max_user_instances=8192' 'fs.inotify.max_user_watches=524288' | sudo tee /etc/sysctl.d/99-inotify.conf
sudo sysctl --system # apply now
```

Without systemd, use the `[boot]` command in `/etc/wsl.conf` instead:

```ini
[boot]
command="sysctl --write fs.inotify.max_user_instances=8192 && sysctl --write fs.inotify.max_user_watches=524288"
```

--------------------------------------------------------------------------------
## LSP server configurations ~
--------------------------------------------------------------------------------
* https://github.com/neovim/nvim-lspconfig
--------------------------------------------------------------------------------
