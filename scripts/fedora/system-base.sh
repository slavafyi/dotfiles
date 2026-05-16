#!/usr/bin/env bash

setup_mirrors() {
  print_in_purple "Configuring mirrors..."
  sleep 2
  print_in_yellow "⚠ Fedora uses DNF metalink/mirror defaults; no mirror rewrite needed"
}

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
  print_in_purple "Checking firmware updates..."
  sleep 2

  if ! command -v fwupdmgr > /dev/null 2>&1; then
    sudo dnf install -y fwupd > /dev/null 2>&1 || {
      print_in_yellow "⚠ fwupd unavailable, skipping firmware checks"
      return 0
    }
  fi

  set +e
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-devices
  sudo fwupdmgr update
  set -e
  print_in_green "✓ Firmware check completed"
}

system_base() {
  setup_mirrors
  setup_base_packages
  setup_system_settings
  update_system
  update_firmware
}
