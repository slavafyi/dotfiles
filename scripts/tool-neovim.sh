#!/usr/bin/env bash

source ./scripts/utils.sh

print_in_purple "Installing neovim..."

mkdir -p /tmp/neovim
cd /tmp/neovim
git clone https://github.com/neovim/neovim .
git checkout stable
sudo make CMAKE_BUILD_TYPE=Release
sudo make install
cd ~/
rm -rf /tmp/neovim

print_in_green "Neovim installed successfully!"
