# NVIM 0.11

This is my little readme for my neovim setup. It can get overwhelming keeping up with updates and breaking plugins and API's so I wanted to keep track of whatever I think may be important here.

## Configuration Load Order

1. ./init.lua
2. ./kalenmichael/init.lua
3. Lazy(./plugins/*)
4. ./kalenmichael/reamp.lua
5. ./kalenmichael/set.lua

## Plugins

### Essentials

**Lazy**
Plugin manager for Neovim that optimizes loading by only loading plugins when needed, improving startup time.

**Mason**
Simplifies the installation, management, and configuration of external tools like language servers, linters, and formatters.

**Language Server (LSP)**
Provides features like autocompletion, linting, and error checking.

vue-language-server: requires plugin configuration with ts_ls in order to work in scripts

**Conform**
Lightweight yet powerful formatter plugin for Neovim

**cmp**
Completions

**Comment**
Smart and Powerful commenting plugin for neovim

### Optional


## Troubleshooting

LSP

LspInfo
LspLog

Formatting

ConformInfo
