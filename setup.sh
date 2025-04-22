#!/bin/bash

set -ex

# remove existed configs that are not Stow's symlink
git checkout main
[[ -n $(git status --ignore-submodules=dirty | grep "Changes not staged for commit") ]] && ( echo "You should stage/commit edited files before running the scripts, as the script is going to restore the git HEAD. Exiting."; exit 1; )
stow --adopt --stow .
git checkout HEAD
stow --restow .
