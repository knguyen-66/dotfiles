#!/usr/bin/env bash

set -ex

[[ -n "$(command -v aichat)" ]] && { echo "aichat already installed. Exiting. "; exit 0; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
NAME=aichat-v0.30.0

curl -Lo "${SCRIPT_DIR}/${NAME}.tar.gz" "https://github.com/sigoden/aichat/releases/download/v0.30.0/aichat-v0.30.0-x86_64-unknown-linux-musl.tar.gz"
tar xf "${SCRIPT_DIR}/${NAME}.tar.gz" -C "${SCRIPT_DIR}"

sudo ln -sf "${SCRIPT_DIR}/aichat" "$HOME/.local/bin/aichat"
