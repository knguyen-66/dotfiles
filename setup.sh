#!/usr/bin/env bash

set -e

INSTALL_APPS=

printlog() {
  case "$1" in
    "info")     { printf "\033[0;34m${2}\033[0m\n"; } ;;
    "info2")    { printf "\033[0;36m${2}\033[0m\n"; } ;;
    "warning")  { printf "\033[0;33m${2}\033[0m\n"; } ;;
    "danger")   { printf "\033[0;31m${2}\033[0m\n"; } ;;
    "success")  { printf "\033[0;32m${2}\033[0m\n"; } ;;
    *)          { echo "Invalid echo color"; return 1; } ;;
  esac
}

printhelp () {
  echo "setup.sh: Setup dotfiles script."
  echo ""
  echo "Syntax: ./setup.sh [-a][-h]"
  echo "Arguments:"
  echo "  -a | --with-apps: install system apps, mainly for interactive systems like personal machine. You can skip it for setup on servers / non-interactive systems."
  echo "  -h | --help     : show help. "
}

while (( "$#" )); do
    case "$1" in
      -a|--with-apps)
        INSTALL_APPS=true
        shift
        ;;
      -h|--help)
        printhelp
        exit 0
        ;;
      -*)
        echo "Error: Unknown options '$1'"
        printhelp
        exit 1
        ;;
      *)
        shift
        ;;
    esac
done

# # TODO: update later when script is POSIX-compatible
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

printlog info "===== SETUP.SH ====="

# # Create ~/.local/bin/ and export to PATH if it doesn't exist
if [ ! -d "$HOME/.local/bin" ]; then
  mkdir -p "$HOME/.local/bin"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

printlog info "\n==== Pre-dotfile-setup process ====\n"

PRE_SETUP_SCRIPTS=$(find scripts/pre-setup -maxdepth 2 -type f -name "*.sh")
while IFS= read -r line; do
  printlog info2 "Running ${line}"
  eval "$line"
done <<< "${PRE_SETUP_SCRIPTS}"

if [[ -n "${INSTALL_APPS}" ]]; then
  printlog info2 "\n==== '-a' option is enabled, installing specified apps ====\n"
  APP_SCRIPTS=$(find scripts/interactive-apps -maxdepth 2 -type f -name "*.sh")
  while IFS= read -r line; do
    printlog info2 "Running ${line}"
    eval "$line"
  done <<< "${APP_SCRIPTS}"
fi

printlog info "\n==== Loading dotfile resources ====\n"

# remove existed configs that are not Stow's symlink
git checkout main
[[ -n $(git status --ignore-submodules=dirty | grep "Changes not staged for commit") ]] && ( printlog warning "You should stage/commit edited files before running the scripts, as the script is going to restore the git HEAD. Exiting."; exit 1; )
stow --adopt --stow .
git checkout HEAD
stow --restow .

printlog info "\n==== Post-dotfile-setup process ====\n"

POST_SETUP_SCRIPTS=$(find scripts/post-setup -maxdepth 2 -type f -name "*.sh")
while IFS= read -r line; do
  printlog info2 "Running ${line}"
  eval "$line"
done <<< "${POST_SETUP_SCRIPTS}"
