#!/usr/bin/env bash
# shellcheck disable=SC1091

set -e
source "${PWD}/config.sh"

describeTask() {
  echo ""
  echo ":: $(tput bold)${DOTFILE_STEP}$(tput sgr0)"
}

describeTaskSuccess() {
  echo "   Successful"
}

fin() {
  echo ""
  echo "!! $(tput bold)Process complete. Good day.$(tput sgr0)"
  echo ""
  exit 0
}

# ===
# Apt
# ===
DOTFILE_STEP="Checking for Apt package manager" describeTask
if command -v "sudo" &> /dev/null; then
  echo "   Okay, cool. Sudo exists. Proceeding."
else
  echo "   Sudo is not installed. Please elevate to a root user and install the sudo package."
  exit 1
fi
if command -v "apt-get" &> /dev/null; then
  sudo apt-get update
  sudo apt-get dist-upgrade -y
  echo "   Installing custom repositories"
  "${PWD}/apt/repos.sh"
  echo "   Installing packages"
  while read -r line; do
    sudo apt-get -y install "$line"
  done < "${PWD}/apt/apt.list"
fi
describeTaskSuccess

# =====
# Cargo
# =====

CARGO_CRATES_LIST="${PWD}/cargo/crates.list"
DOTFILE_STEP="Installing Cargo crates" describeTask
set +e
diff <(cargo install --list | awk '/^\w/ { print $1 }') "${CARGO_CRATES_LIST}" > /dev/null 2>&1
if [ $? == "1" ]; then
  echo "   There is a mismatch between the currently installed crates and proposed list"
  echo "   Installing crates..."
  set -e
  grep -v '^ *#' < "${CARGO_CRATES_LIST}" | while IFS= read -r CRATE
  do
    cargo install "$CRATE"
  done
  describeTaskSuccess
else
  set -e
  echo "   Crates list matches, skipping"
fi

# ================
# Citrix Workspace
# ================
DOTFILE_STEP="Setting up Citrix Workspace" describeTask
echo "TODO"

# ===
# Git
# ===
DOTFILE_STEP="Templating Git configuration" describeTask
cat <<EOF > "${HOME}/.gitconfig"
# Do not modify this file by hand - you will have a bad time
# This is generated by the santiagon610/dotfiles install script

[user]
  name  = "${USER_DISPLAYNAME}"
  email = "${USER_EMAIL}"

[pull]
  ff = only
EOF
describeTaskSuccess

# ========
# Neofetch
# ========
if [ -z "${NEOFETCH_CONFIG_PATH}" ]; then
  DOTFILE_STEP="Creating Neofetch config directory" describeTask
  mkdir -p "${NEOFETCH_CONFIG_PATH}"
else
  DOTFILE_STEP="Neofetch config directory exists, skipping" describeTask
fi
DOTFILE_STEP="Copying Neofetch configuration file" describeTask
cp "${PWD}/neofetch/neofetch.conf" "${NEOFETCH_CONFIG_PATH}/config.conf" && describeTaskSuccess

# ========
# Topgrade
# ========
DOTFILE_STEP="Copying Topgrade configuration file" describeTask
cp "${PWD}/topgrade/topgrade.toml" "${TOPGRADE_CONFIG_PATH}/topgrade.toml" && describeTaskSuccess

# ==================
# Visual Studio Code
# ==================
VSCODE_EXTENIONS_LIST="${PWD}/vscode/extensions.list"
DOTFILE_STEP="Copying Visual Studio Code configuration file" describeTask
cp "${PWD}/vscode/settings.json" "${VSCODE_CONFIG_PATH}/settings.json" && describeTaskSuccess

DOTFILE_STEP="Checking installed extensions against proposed list" describeTask
set +e
diff <(code --list-extensions) "${VSCODE_EXTENIONS_LIST}" > /dev/null 2>&1
if [ $? == "1" ]; then
  echo "   There is a mismatch between the currently installed extensions and proposed list"
  echo "   Installing extensions..."
  set -e
  grep -v '^ *#' < "${VSCODE_EXTENIONS_LIST}" | while IFS= read -r ext
  do
    code --install-extension "$ext"
  done
  describeTaskSuccess
else
  set -e
  echo "   Extensions list matches, skipping"
fi

# ===
# zsh
# ===
DOTFILE_STEP="Copying Zsh aliases" describeTask
cp "${PWD}/zsh/aliases.sh" "${HOME}/.aliases.sh" && describeTaskSuccess
DOTFILE_STEP="Copying Zsh weather function" describeTask
cp "${PWD}/zsh/aliases-wx.sh" "${HOME}/.aliases-wx.sh" && describeTaskSuccess

# =========
# Finish up
# =========
fin