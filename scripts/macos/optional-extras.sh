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

setup_zeit() {
  print_in_purple "Setting up Zeit..."
  sleep 2
  local arch=$(uname -m)
  local version=$(curl -s "https://api.github.com/repos/mrusme/zeit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  local temp_path=$(mktemp -d)
  local tarball="zeit_${version}_darwin_${arch}.tar.gz"
  local url="https://github.com/mrusme/zeit/releases/download/v${version}/${tarball}"
  cd "$temp_path"
  curl -LO "$url"
  tar xf "$tarball" zeit
  sudo install -m 755 zeit /usr/local/bin/zeit
  cd "$DIR"
  zeit completion fish > "$XDG_CONFIG_HOME/fish/completions/zeit.fish"
  print_in_green "✓ Zeit set up successfully!"
}

optional_extras() {
  setup_obsidian
  setup_zeit
}
