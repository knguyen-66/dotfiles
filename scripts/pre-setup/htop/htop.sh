#!/usr/bin/env bash

set -ex

[[ -n "$(command -v htop)" ]] && { echo "Htop already installed. Exiting. "; exit 0; }

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PKGMGR="$("${SCRIPT_DIR}/../../get-os-info.sh" --pkg)"

sudo $PKGMGR htop
