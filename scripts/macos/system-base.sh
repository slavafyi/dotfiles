#!/usr/bin/env bash

add_homebrew() {
  print_in_purple "Installing Homebrew..."
  sleep 2
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_in_green "Homebrew installed successfully!"
  else
    print_in_yellow "Homebrew already installed"
  fi
}

add_packages() {
  print_in_purple "Installing base packages..."
  sleep 2
  local packages="$DIR/packages/base-brew.txt"
  brew bundle --file="$packages"
  if ! xcode-select --print-path &> /dev/null; then
    xcode-select --install &> /dev/null
  fi
  print_in_green "Base packages installed successfully!"
}

system_update() {
  print_in_purple "Updating the system..."
  sleep 2
  brew update --quiet > /dev/null 2>&1
  print_in_green "System updated successfully!"
}

system_base() {
  system_update
  add_homebrew
  add_packages
}
