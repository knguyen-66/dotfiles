#!/usr/bin/env bash

set -ex

# TODO: test support later
echo "IBus-Bamboo installation unsupported for now. Skipping. "
exit 0

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DISTRO="$("${SCRIPT_DIR}/../../get-os-info.sh" --distro)"

case $DISTRO in
	debian)
		sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
		sudo apt update
		sudo apt install ibus ibus-bamboo --install-recommends
		ibus restart
		;;
	*)
		echo "No installation supports for other distros for now. Skipping. "
		exit 0
		;;
esac

# Đặt ibus-bamboo làm bộ gõ mặc định
# env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

