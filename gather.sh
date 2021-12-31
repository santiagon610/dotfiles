#!/usr/bin/env bash
# shellcheck disable=SC1091

set -e
source "${PWD}/config.sh"

# Cargo
cargo install --list | awk '/^\w/ { print $1 }' > "${PWD}/cargo/cargo.list"

# Git
cp "${HOME}/.gitconfig" "${PWD}/git/gitconfig.gathered"

# Homebrew
if [ -f "${PWD}/homebrew/Brewfile" ]; then
  rm -f "${PWD}/homebrew/Brewfile"
fi
(cd "${PWD}/homebrew" && brew bundle dump)

# Neofetch
cp "${NEOFETCH_CONFIG_PATH}/config.conf" "${PWD}/neofetch/neofetch.conf" 

# Visual Studio Code
cp "${VSCODE_CONFIG_PATH}/settings.json" "${PWD}/vscode/settings.json"
code --list-extensions > "${PWD}/vscode/extensions.list"