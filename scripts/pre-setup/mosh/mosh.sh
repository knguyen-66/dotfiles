#!/usr/bin/env bash

set -ex

# get current script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PKGMGR="$("${SCRIPT_DIR}/../../get-os-info.sh" --pkg)"

sudo $PKGMGR mosh
