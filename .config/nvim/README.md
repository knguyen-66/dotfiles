# Minimal Neovim config

## Introduction

Configurations for Neovim that is:

* Small
* Dependency-minimal
* Supported for multiple versions

Mainly derived from:

* [VonHeikemen/nvim-light](https://github.com/VonHeikemen/nvim-light)
* [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## Requirements

* Neovim v0.9 or greater
* Basic utils: `git`, `make`, `unzip`, C compiler (`gcc`)
* [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
* [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md#installation)
* A Nerd Font

## Notes

If you want to have separate nvim environments, use alias in `.bashrc`/`.zshrc`/...
For example:
```
alias nvimtest9="NVIM_APPNAME=nvim-v0_9 /home/knguyen-66/nvim-0_9/bin/nvim"
```
