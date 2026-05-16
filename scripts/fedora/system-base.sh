#!/usr/bin/env bash

setup_base_packages() {
  print_in_purple "Installing base packages..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/base.txt"
  xargs -r -a "$packages" sudo dnf install -y
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
  sudo dnf upgrade -y
  print_in_green "✓ System updated successfully!"
}

update_firmware() {
  print_in_purple "Updating firmware..."
  sleep 2
  sudo dnf install -y fwupd
  set +e
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-devices
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
  set -e
  print_in_green "✓ Firmware updated successfully!"
}

system_base() {
  setup_base_packages
  setup_system_settings
  update_system
  update_firmware
}
