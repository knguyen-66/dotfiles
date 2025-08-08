#!/bin/bash

set -ex

# # Conditionally add `$HOME/.local/bin` to the `PATH` in any given shell rc file
# update_shell_rc() {
#   local shell_rc=$1
#   if [ -f "$shell_rc" ]; then
#     if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$shell_rc"; then
#       echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_rc"
#     fi
#   fi
# }
#
# # Create ~/.local/bin/ if it doesn't exist
# if [ ! -d "$HOME/.local/bin" ]; then
#   mkdir -p "$HOME/.local/bin"
# fi

PRE_SETUP_SCRIPTS=$(find scripts/pre-setup -maxdepth 2 -type f -name "*.sh")
while IFS= read -r line; do
  eval "$line"
done <<< "${PRE_SETUP_SCRIPTS}"

# remove existed configs that are not Stow's symlink
git checkout main
[[ -n $(git status --ignore-submodules=dirty | grep "Changes not staged for commit") ]] && ( echo "You should stage/commit edited files before running the scripts, as the script is going to restore the git HEAD. Exiting."; exit 1; )
stow --adopt --stow .
git checkout HEAD
stow --restow .

POST_SETUP_SCRIPTS=$(find scripts/post-setup -maxdepth 2 -type f -name "*.sh")
while IFS= read -r line; do
  eval "$line"
done <<< "${POST_SETUP_SCRIPTS}"
