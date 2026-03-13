#!/usr/bin/env bash

setup_obsidian() {
  print_in_purple "Setting up Obsidian and vault..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed obsidian
  local vault_path="$HOME/obsidian/personal"
  if [ ! -d "$vault_path" ]; then
    print_in_purple "Adding vault..."
    mkdir -pv "$HOME/obsidian"
    git clone git@github.com:slavafyi/obsidian-vault.git "$vault_path"
  else
    print_in_yellow "⚠ Personal vault already exists, skipping"
  fi
  print_in_green "✓ Obsidian installed successfully!"
}

setup_zk() {
  print_in_purple "Setting up zk..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed zk
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow zk
  print_in_green "✓ Zk set up successfully!"
}

setup_notes() {
  print_in_purple "Setting up notes..."
  sleep 2
  local notes_path="${NOTES_DIR:-$HOME/notes}"
  if [ ! -d "$notes_path" ]; then
    print_in_purple "Adding notes..."
    git clone git@github.com:slavafyi/notes.git "$notes_path"
  else
    print_in_yellow "⚠ Notes already exists, skipping"
  fi
  print_in_green "✓ Notes set up successfully!"
}

setup_easyeffects() {
  print_in_purple "Setting up EasyEffects..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed easyeffects lsp-plugins calf
  local base_config="$XDG_CONFIG_HOME/easyeffects"
  local config_dir="$base_config/output"
  local irs_dir="$base_config/irs"
  mkdir -p "$config_dir" "$irs_dir"
  local fw_url="https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects"
  curl -fo "$config_dir/fw13-easy-effects.json" "$fw_url/fw13-easy-effects.json"
  curl -fo "$irs_dir/IR_22ms_27dB_5t_15s_0c.irs" "$fw_url/irs/IR_22ms_27dB_5t_15s_0c.irs"
  print_in_green "✓ EasyEffects installed successfully!"
}

optional_extras() {
  setup_easyeffects
  setup_zk
  setup_notes
}
