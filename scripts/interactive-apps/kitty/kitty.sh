#!/usr/bin/env bash

set -ex

[[ -n "$(command -v kitty)" ]] && { echo "Kitty already installed. Exiting. "; exit 0; }

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

# Binaries will be setup at ~/.local/kitty.app
chmod +x "${HOME}/.local/kitty.app/bin/kitty"
chmod +x "${HOME}/.local/kitty.app/bin/kitten"

# Setup symlinks
sudo ln -s "${HOME}/.local/kitty.app/bin/kitty" /usr/local/bin/kitty
sudo ln -s "${HOME}/.local/kitty.app/bin/kitten" /usr/local/bin/kitten
