#!/usr/bin/env bash

[[ -n "$(command -v code)" ]] && { echo "VSCode already installed. Exiting. "; exit 0; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DISTRO="$("${SCRIPT_DIR}/../../get-os-info.sh" --distro)"
NAME=code

[[ "${DISTRO}" != "debian" ]] && { echo "Script only support Ubuntu/Debian for now. Exiting."; exit 0; }

curl -Lo "${SCRIPT_DIR}/${NAME}.deb" "https://update.code.visualstudio.com/1.147.0/linux-deb-x64/stable"
sudo dpkg -i "${SCRIPT_DIR}/${NAME}.deb"

code --install-extension "qufiwefefwoyn.kanagawa" "vscodevim.vim"
