#!/usr/bin/env bash

setup_base_packages() {
  print_in_purple "Installing base packages..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/base.txt"
  sudo apt update
  xargs -r -a "$packages" sudo apt install -yy
  print_in_green "✓ Base packages installed successfully!"
}

setup_system_settings() {
  print_in_purple "Configuring system settings..."
  sleep 2
  sudo timedatectl set-local-rtc false
  sudo timedatectl set-timezone Europe/Moscow
  print_in_green "✓ System settings configured successfully!"
}

update_system() {
  print_in_purple "Updating the system..."
  sleep 2
  sudo apt update
  sudo apt upgrade -yy
  print_in_green "✓ System updated successfully!"
}

system_base() {
  setup_base_packages
  setup_system_settings
  update_system
}
