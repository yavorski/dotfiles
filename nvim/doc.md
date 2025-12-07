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

* Use `bin/roslyn-update.sh`
* Download `Microsoft.CodeAnalysis.LanguageServer.linux-x64` from `https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl`
* Extract `<zip-root>/content/LanguageServer/<yourArch>` and move to:
  - Linux: `~/.local/share/nvim/roslyn`
  - Windows: `%LOCALAPPDATA%\nvim-data\roslyn`
* Verify with `dotnet Microsoft.CodeAnalysis.LanguageServer.dll --version`

--------------------------------------------------------------------------------
## LSP server configurations ~
--------------------------------------------------------------------------------
* https://github.com/neovim/nvim-lspconfig
--------------------------------------------------------------------------------
