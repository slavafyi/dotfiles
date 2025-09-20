#!/usr/bin/env bash

setup_settings() {
  print_in_purple "Applying desktop settings..."
  sleep 2

  print_in_green "Desktop settings applied successfully!"
}

install_apps() {
  print_in_purple "Installing desktop apps..."
  sleep 2
  local packages="$DIR/packages/apps-brew.txt"
  brew bundle --file="$packages"
  print_in_green "Desktop apps installed successfully!"
}

setup_fonts() {
  print_in_purple "Installing additional fonts..."
  sleep 2
  local packages="$DIR/packages/fonts-brew.txt"
  brew bundle --file="$packages"
  print_in_green "Additional fonts installed successfully!"
}

setup_terminal() {
  print_in_purple "Setting up ghostty configuration..."
  sleep 2
  brew install --cask ghostty
  local config_path="$HOME/.config/ghostty/config"
  mkdir -pv "$HOME/.config/ghostty/themes"
  if [ -f "$config_path" ]; then
    rm -f "$config_path"
  fi
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ghostty
  print_in_green "Ghostty configuration set up successfully!"
}

desktop_env() {
  setup_settings
  install_apps
  setup_fonts
  setup_terminal
}
