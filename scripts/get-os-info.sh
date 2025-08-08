#!/usr/bin/env bash

declare -A osInfo;

case "$1" in
	--pkg)
		osInfo[/etc/debian_version]="apt install -y"
		osInfo[/etc/arch-release]="pacman -S"
		osInfo[/etc/redhat-release]="yum install -y"
		osInfo[/etc/centos-release]="yum install -y"
		osInfo[/etc/gentoo-release]="emerge -pv"
		osInfo[/etc/SuSE-release]="zypper -n install"
		osInfo[/etc/alpine-release]="apk --update add"
		;;
	--distro)
		osInfo[/etc/debian_version]="debian"
		osInfo[/etc/arch-release]="arch"
		osInfo[/etc/redhat-release]="fedora"
		osInfo[/etc/centos-release]="centos"
		osInfo[/etc/gentoo-release]="gentoo"
		osInfo[/etc/SuSE-release]="suse"
		osInfo[/etc/alpine-release]="alpine"
		;;
	*)
		echo "get-os-info.sh: Unsupported type"
		exit 1
		;;
esac


for f in "${!osInfo[@]}"; do
	if [[ -f $f ]]; then
		# PKG_MANAGER="${osInfo[$f]}"
		echo "${osInfo[$f]}"
	fi
done
