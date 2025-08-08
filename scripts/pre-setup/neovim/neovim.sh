#!/usr/bin/env bash

set -ex

[[ -n "$(command -v nvim)" ]] && { echo "NeoVim already installed. Exiting. "; exit 0; }

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

curl -Lo "${SCRIPT_DIR}/nvim-linux-x86_64.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
tar xf "${SCRIPT_DIR}/nvim-linux-x86_64.tar.gz" -C "${SCRIPT_DIR}"

## create symlink
sudo ln -s "${SCRIPT_DIR}/nvim-linux-x86_64/bin/nvim" /usr/local/bin/nvim
