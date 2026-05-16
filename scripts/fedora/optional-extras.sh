#!/usr/bin/env bash

setup_obsidian() {
  print_in_purple "Setting up Obsidian and vault..."
  sleep 2

  if ! sudo dnf install -y obsidian; then
    print_in_yellow "⚠ Obsidian package unavailable from default repositories; install manually if needed"
    return 0
  fi

  local vault_path="$HOME/obsidian/personal"
  if [ ! -d "$vault_path" ]; then
    print_in_purple "Adding vault..."
    sudo dnf install -y git || {
      print_in_yellow "⚠ git unavailable; skipping vault clone"
      return 0
    }
    mkdir -pv "$HOME/obsidian"
    git clone git@github.com:slavafyi/obsidian-vault.git "$vault_path"
  else
    print_in_yellow "⚠ Personal vault already exists, skipping"
  fi
  print_in_green "✓ Obsidian set up successfully!"
}

setup_zk() {
  print_in_purple "Setting up zk..."
  sleep 2
  if command -v zk > /dev/null 2>&1; then
    print_in_yellow "⚠ zk already installed, skipping"
  elif ! sudo dnf install -y zk; then
    print_in_yellow "⚠ zk not available from safe Fedora sources; skipping"
    return 0
  fi

  sudo dnf install -y stow
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
    sudo dnf install -y git || {
      print_in_yellow "⚠ git unavailable; skipping notes clone"
      return 0
    }
    git clone git@github.com:slavafyi/notes.git "$notes_path"
  else
    print_in_yellow "⚠ Notes already exists, skipping"
  fi
  print_in_green "✓ Notes set up successfully!"
}

setup_easyeffects() {
  print_in_purple "Setting up EasyEffects..."
  sleep 2

  local package
  for package in easyeffects calf lsp-plugins; do
    if ! sudo dnf install -y "$package"; then
      print_in_yellow "⚠ $package package unavailable; skipping remaining EasyEffects setup"
      return 0
    fi
  done

  local base_config="$XDG_CONFIG_HOME/easyeffects"
  local config_dir="$base_config/output"
  local irs_dir="$base_config/irs"
  sudo dnf install -y curl || {
    print_in_yellow "⚠ curl unavailable; skipping EasyEffects preset download"
    return 0
  }
  mkdir -p "$config_dir" "$irs_dir"
  curl -fo "$config_dir/fw13-easy-effects.json" "https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects/fw13-easy-effects.json"
  curl -fo "$irs_dir/IR_22ms_27dB_5t_15s_0c.irs" "https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects/irs/IR_22ms_27dB_5t_15s_0c.irs"
  print_in_green "✓ EasyEffects set up successfully!"
}

optional_extras() {
  setup_easyeffects
  setup_zk
  setup_notes
}
