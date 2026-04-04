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

setup_zk() {
  print_in_purple "Setting up zk..."
  sleep 2
  brew install zk
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow zk
  print_in_green "✓ Zk set up successfully!"
}

setup_notes() {
  print_in_purple "Setting up notes..."
  sleep 2
  local notes_path="${NOTES_DIR:-$HOME/notes}"
  if [ ! -d "$notes_path" ]; then
    print_in_purple "Adding notes..."
    git clone git@github.com:slavafyi/notes.git "$notes_path"
  else
    print_in_yellow "⚠ Notes already exists, skipping"
  fi
  print_in_green "✓ Notes set up successfully!"
}

optional_extras() {
  setup_zk
  setup_notes
}
