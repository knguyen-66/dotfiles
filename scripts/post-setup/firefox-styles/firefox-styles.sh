#!/usr/bin/env bash

set -x

[[ -z "$(command -v firefox)" ]] && { echo "Firefox not installed. Need to install firefox manually first. Exiting. "; exit 0; }

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PKG_LOCATION="$HOME/.mozilla/firefox" # Default for apt or manual install
FLATPAK_LOCATION="$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox" # Flatpak install
# "$HOME/snap/firefox/common/.mozilla/firefox" # I won't ever use Snap shits

PROFILE_DIRS=""
[[ -d "${PKG_LOCATION}" ]] && PROFILE_DIRS+=$(find "${PKG_LOCATION}" -maxdepth 1 -type d -name "*.default*")
[[ -d "${FLATPAK_LOCATION}" ]] && PROFILE_DIRS+=$(find "${FLATPAK_LOCATION}" -maxdepth 1 -type d -name "*.default*")

if [[ -n "${PROFILE_DIRS}" ]]; then
	# apply styling to all profiles
	while IFS= read -r line; do
		! [[ -d "${line}/chrome" ]] && { mkdir "${line}/chrome"; }
		ln -s "${SCRIPT_DIR}/userChrome.css" "${line}/chrome/userChrome.css"
	done <<< "${PROFILE_DIRS}"
	echo "Note: Starting with Firefox 69 you have to enable toolkit.legacyUserProfileCustomizations.stylesheets in about:config."
fi
