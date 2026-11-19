#!/usr/bin/env bash

[[ -n "$(command -v tree-sitter-cli)" ]] && { echo "tree-sitter-cli already installed. Exiting. "; exit 0; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PKGMGR="$("${SCRIPT_DIR}/../../get-os-info.sh" --pkg)"
[[ -n "$(command -v unzip)" ]] && sudo $PKGMGR unzip

curl -Lo "${SCRIPT_DIR}/tree-sitter-cli-linux-x64.zip" "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.2/tree-sitter-cli-linux-x64.zip"
unzip "${SCRIPT_DIR}/tree-sitter-cli-linux-x64.zip" -d "${SCRIPT_DIR}"

sudo ln -sf "${SCRIPT_DIR}/tree-sitter" "$HOME/.local/bin/tree-sitter"
