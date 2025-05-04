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

install_additional_tools() {
  print_in_purple "Installing additional development tools..."
  sleep 2
  local packages="$DIR/packages/dev-tools.txt"
  yay -Sy --noconfirm --needed - < "$packages"
  print_in_green "Additional development tools installed successfully!"
}

dev_tools() {
  setup_mise
  setup_docker
  setup_neovim
  install_additional_tools
}
