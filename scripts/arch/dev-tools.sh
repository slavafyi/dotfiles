#!/usr/bin/env bash

setup_mise() {
  print_in_purple "Setting up mise configuration..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed mise usage
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow mise
  mise completion fish > "$HOME/.config/fish/completions/mise.fish"
  mise install
  print_in_green "Mise configuration set up successfully!"
}

setup_docker() {
  print_in_purple "Setting up docker configuration..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed docker docker-compose
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
  sudo usermod -aG docker $USER
  print_in_green "Docker configuration set up successfully!"
}

setup_neovim() {
  print_in_purple "Setting up neovim configuration..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed neovim
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow neovim
  local plugins_path="$HOME/.local/share/nvim/site/pack/plugins/start"
  mkdir -pv "$plugins_path"
  if [ ! -d "$plugins_path/papercolor-theme-slim" ]; then
    cd "$plugins_path"
    git clone https://github.com/pappasam/papercolor-theme-slim
    cd "$DIR"
  fi
  print_in_green "Neovim configuration set up successfully!"
}

setup_tmux() {
  print_in_purple "Setting up tmux configuration..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed tmux
  local tmp_plugins_path="$HOME/.tmux/plugins"
  mkdir -pv "$tmp_plugins_path"
  if [ ! -d "$tmp_plugins_path/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$tmp_plugins_path/tpm"
  fi
  local tms_temp_path="/tmp/tms"
  mkdir -pv "$HOME/.config/tms"
  if [ ! -d "$tms_temp_path" ]; then
    git clone https://github.com/jrmoulton/tmux-sessionizer.git "$tms_temp_path"
    cargo install --path "$tms_temp_path" --force
    echo "COMPLETE=fish tms | source" > "$HOME/.config/fish/completions/tms.fish"
  fi
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow tmux
  print_in_green "Tmux configuration set up successfully!"
}

install_additional_tools() {
  print_in_purple "Installing additional development tools..."
  sleep 2
  local packages="$DIR/packages/dev-tools.txt"
  yay -Sy --noconfirm --needed - < "$packages"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow tools
  print_in_green "Additional development tools installed successfully!"
}

dev_tools() {
  setup_mise
  setup_docker
  setup_neovim
  setup_tmux
  install_additional_tools
}
