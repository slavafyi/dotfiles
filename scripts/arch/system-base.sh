#!/usr/bin/env bash

configure_mirrors() {
  print_in_purple "Configuring mirrors..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed reflector
  sudo reflector \
    --verbose \
    --fastest 10 \
    --protocol https \
    --sort country \
    --country ru,se,kz,by,ua,fi \
    --save /etc/pacman.d/mirrorlist
  print_in_green "✓ Mirrors configured successfully!"
}

install_base_packages() {
  print_in_purple "Installing base packages..."
  sleep 2
  local packages="$DIR/packages/$OS/base.txt"
  sudo pacman -Sy --noconfirm --needed - < "$packages"
  print_in_green "✓ Base packages installed successfully!"
}

configure_settings() {
  print_in_purple "Configuring system settings..."
  sleep 2
  sudo timedatectl set-local-rtc false
  sudo timedatectl set-timezone Europe/Moscow
  print_in_green "✓ System settings configured successfully!"
}

update_system() {
  print_in_purple "Updating the system..."
  sleep 2
  sudo pacman -Syu --noconfirm
  print_in_green "✓ System updated successfully!"
}

update_firmware() {
  print_in_purple "Updating firmware..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed fwupd
  set +e
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-devices
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
  set -e
  print_in_green "✓ Firmware updated successfully!"
}

system_base() {
  configure_mirrors
  install_base_packages
  configure_settings
  update_system
  update_firmware
}
