#!/bin/bash

set -e

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

INSTALL_APPS=

print_help () {
  echo "setup.sh: Setup dotfiles script."
  echo ""
  echo "Syntax: ./setup.sh [-a|h]"
  echo "Arguments:"
  echo "  -a | --with-apps: install system apps, mainly for interactive systems like personal machine. You can skip it for setup on servers / non-interactive-login systems."
  echo "  -h | --help: show help. "
}

while (( "$#" )); do
    case "$1" in
      -a|--with-apps)
        INSTALL_APPS=true
        shift
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      -*)
        echo "Error: Unknown options '$1'"
        print_help
        exit 1
        ;;
      *)
        shift
        ;;
    esac
done

echo -e "\n==== Pre-dotfile-setup process ====\n"
PRE_SETUP_SCRIPTS=$(find scripts/pre-setup -maxdepth 2 -type f -name "*.sh")
while IFS= read -r line; do
  eval "$line"
done <<< "${PRE_SETUP_SCRIPTS}"

if [[ -n "${INSTALL_APPS}" ]]; then
  echo -e "\n==== '-a' option is enabled, installing specified apps ====\n"
  APP_SCRIPTS=$(find scripts/interactive-apps -maxdepth 2 -type f -name "*.sh")
  while IFS= read -r line; do
    eval "$line"
  done <<< "${APP_SCRIPTS}"
fi

echo -e "\n==== Loading dotfiles to their respective locations ====\n"
# remove existed configs that are not Stow's symlink
git checkout main
[[ -n $(git status --ignore-submodules=dirty | grep "Changes not staged for commit") ]] && ( echo "You should stage/commit edited files before running the scripts, as the script is going to restore the git HEAD. Exiting."; exit 1; )
stow --adopt --stow .
git checkout HEAD
stow --restow .

echo -e "\n==== Post-dotfile-setup process ====\n"
POST_SETUP_SCRIPTS=$(find scripts/post-setup -maxdepth 2 -type f -name "*.sh")
while IFS= read -r line; do
  eval "$line"
done <<< "${POST_SETUP_SCRIPTS}"
