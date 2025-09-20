#!/usr/bin/env bash

setup_obsidian() {
  print_in_purple "Setting up Obsidian and configuring vault..."
  sleep 2
  brew install --cask obsidian
  local vault_path="$HOME/obsidian/personal"
  if [ ! -d "$vault_path" ]; then
    mkdir -pv "$HOME/obsidian"
    git clone git@github.com:slavafyi/obsidian-vault.git "$vault_path"
  else
    print_in_yellow "Personal vault already exists. Skipping vault creation."
  fi
  print_in_green "Obsidian installed successfully!"
}

optional_extras() {
  setup_obsidian
}
