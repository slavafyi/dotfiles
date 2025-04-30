#!/usr/bin/env bash

add_mirrors() {
  print_in_purple "Adding mirrors..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed reflector
  sudo reflector \
    --verbose \
    --fastest 10 \
    --protocol https \
    --sort country \
    --country ru,se,kz,by,ua,fi \
    --save /etc/pacman.d/mirrorlist
  print_in_green "Mirrors added successfully!"
}

add_packages() {
  print_in_purple "Installing base packages..."
  sleep 2
  local packages="$DIR/packages/base.txt"
  sudo pacman -Sy --noconfirm --needed - < "$packages"
  print_in_green "Base packages installed successfully!"
}

system_settings() {
  print_in_purple "Configuring system settings..."
  sleep 2
  sudo timedatectl set-local-rtc false
  sudo timedatectl set-timezone Europe/Moscow
  print_in_green "System settings configured successfully!"
}

system_update() {
  print_in_purple "Updating the system..."
  sleep 2
  sudo pacman -Syu --noconfirm
  print_in_green "System updated successfully!"
}

firmware_update() {
  print_in_purple "Updating firmware..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed fwupd
  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-devices
  sudo fwupdmgr get-updates
  sudo fwupdmgr update
  print_in_green "Firmware updated successfully!"
}

system_base() {
  add_mirrors
  add_packages
  system_settings
  system_update
  firmware_update
}
