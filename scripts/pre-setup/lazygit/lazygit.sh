#!/usr/bin/env bash

set -ex

[[ -n "$(command -v lazygit)" ]] && { echo "LazyGit already installed. Exiting. "; exit 0; }

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo "${SCRIPT_DIR}/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf "${SCRIPT_DIR}/lazygit.tar.gz" -C "${SCRIPT_DIR}" lazygit

## original
# sudo install "${SCRIPT_DIR}/lazygit" -D -t /usr/local/bin/

## create symlink instead
sudo ln -s "${SCRIPT_DIR}/lazygit" /usr/local/bin/lazygit
