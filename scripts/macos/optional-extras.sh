#!/usr/bin/env bash

setup_obsidian() {
  print_in_purple "Setting up Obsidian and vault..."
  sleep 2
  brew install --cask obsidian
  local vault_path="$HOME/obsidian/personal"
  if [ ! -d "$vault_path" ]; then
    print_in_purple "Adding vault..."
    mkdir -pv "$HOME/obsidian"
    git clone git@github.com:slavafyi/obsidian-vault.git "$vault_path"
  else
    print_in_yellow "⚠ Personal vault already exists, skipping"
  fi
  print_in_green "✓ Obsidian set up successfully!"
}

optional_extras() {
  setup_obsidian
}
