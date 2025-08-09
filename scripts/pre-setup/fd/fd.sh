#!/usr/bin/env bash

set -ex

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PKGMGR="$("${SCRIPT_DIR}/../../get-os-info.sh" --pkg)"
DISTRO="$("${SCRIPT_DIR}/../../get-os-info.sh" --distro)"

case $DISTRO in
	debian|fedora)
		[[ -n "$(command -v fdfind)" ]] && { echo "fd already installed. Exiting. "; exit 0; }
		sudo $PKGMGR fd-find
		## if you need to call the program by the "fd" name
		# sudo ln -s $(which fdfind) ~/.local/bin/fd
		;;
	*)
		[[ -n "$(command -v fd)" ]] && { echo "fd already installed. Exiting. "; exit 0; }
		sudo $PKGMGR fd
		;;
esac


