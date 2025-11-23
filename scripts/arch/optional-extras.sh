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

setup_zeit() {
  print_in_purple "Setting up Zeit..."
  sleep 2
  local arch=$(dpkg --print-architecture)
  local version=$(curl -s "https://api.github.com/repos/mrusme/zeit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  local temp_path=$(mktemp -d)
  local tarball="zeit_${version}_linux_${arch}.tar.gz"
  local url="https://github.com/mrusme/zeit/releases/download/v${version}/${tarball}"
  cd "$temp_path"
  curl -LO "$url"
  tar xf "$tarball" zeit
  sudo install zeit -D -t /usr/local/bin/
  cd "$DIR"
  zeit completion fish > "$XDG_CONFIG_HOME/fish/completions/zeit.fish"
  print_in_green "✓ Zeit set up successfully!"
}

optional_extras() {
  setup_obsidian
  setup_easyeffects
  setup_zeit
}
