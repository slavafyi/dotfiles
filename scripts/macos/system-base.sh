#!/usr/bin/env bash

configure_homebrew() {
  print_in_purple "Configuring Homebrew..."
  sleep 2
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_in_green "✓ Homebrew configured successfully!"
  else
    print_in_yellow "⚠ Homebrew already configured, skipping"
  fi
}

install_base_packages() {
  print_in_purple "Installing base packages..."
  sleep 2
  local packages="$DIR/packages/$OS/base.txt"
  brew bundle --file="$packages"
  if ! xcode-select --print-path &> /dev/null; then
    print_in_purple "Installing xcode..."
    xcode-select --install &> /dev/null
  fi
  print_in_green "✓ Base packages installed successfully!"
}

update_system() {
  print_in_purple "Updating the system..."
  sleep 2
  brew update --quiet > /dev/null 2>&1
  print_in_green "✓ System updated successfully!"
}

system_base() {
  update_system
  configure_homebrew
  install_base_packages
}
