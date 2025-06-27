#!/usr/bin/env bash

setup_obsidian() {
  print_in_purple "Setting up Obsidian and configuring vault..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed obsidian
  local vault_path="$HOME/obsidian/personal"
  if [ ! -d "$vault_path" ]; then
    mkdir -pv "$HOME/obsidian"
    git clone git@github.com:slavafyi/obsidian-vault.git "$vault_path"
  else
    print_in_yellow "Personal vault already exists. Skipping vault creation."
  fi
  print_in_green "Obsidian installed successfully!"
}

setup_easyeffects() {
  print_in_purple "Setting up EasyEffects..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed easyeffects lsp-plugins calf
  local base_config="$HOME/.config/easyeffects"
  local config_dir="$base_config/output"
  local irs_dir="$base_config/irs"
  mkdir -p "$config_dir" "$irs_dir"
  local fw_url="https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects"
  curl -fo "$config_dir/fw13-easy-effects.json" "$fw_url/fw13-easy-effects.json"
  curl -fo "$irs_dir/IR_22ms_27dB_5t_15s_0c.irs" "$fw_url/irs/IR_22ms_27dB_5t_15s_0c.irs"
  print_in_green "EasyEffects installed successfully!"
}


optional_extras() {
  setup_obsidian
  setup_easyeffects
}
