#!/usr/bin/env bash

set -x

cleanup_nvim() {
    sudo rm -rf "$HOME/.local/bin/nvim"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
}

setup_nvim() {
    # get current script path
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    curl -Lo "${SCRIPT_DIR}/nvim-linux-x86_64.tar.gz" "https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-x86_64.tar.gz"
    # curl -Lo "${SCRIPT_DIR}/nvim-linux-x86_64.tar.gz" "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
    tar xf "${SCRIPT_DIR}/nvim-linux-x86_64.tar.gz" -C "${SCRIPT_DIR}"

    ## create symlink
    sudo ln -sf "${SCRIPT_DIR}/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"
}

if [[ -z "$(command -v nvim)" ]]; then  # new setup
    setup_nvim
else
    read -p "NeoVim already installed. Reinstall? (y/N): " reinstall
    if [[ "${reinstall,,}" == "y" ]]; then
        cleanup_nvim
        setup_nvim
    else
        echo "Keeping old version. Exiting."
    fi
fi
