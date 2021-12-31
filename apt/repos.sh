#!/usr/bin/env bash

aptAddHttpsTransport() {
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
}

# Google Chrome
if [[ -f /etc/apt/sources.list.d/google-chrome.list ]]; then
    echo "   Google Chrome repository definition already exists, skipping"
else
    echo "   Creating Google Chrome repository definition"
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
    aptAddHttpsTransport
fi

# Visual Studio Code
if [[ -f /etc/apt/sources.list.d/vscode.list ]]; then
    echo "   VSCode repository definition already exists, skipping"
else
    echo "   Creating VSCode repository definition"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 0644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    aptAddHttpsTransport
fi
