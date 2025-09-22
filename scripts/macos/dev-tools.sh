#!/usr/bin/env bash

setup_mise() {
  print_in_purple "Setting up mise configuration..."
  sleep 2
  brew install mise usage libyaml
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
  brew install --cask orbstack
  print_in_green "Docker configuration set up successfully!"
}

setup_neovim() {
  print_in_purple "Setting up neovim configuration..."
  sleep 2
  brew install neovim
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow neovim
  print_in_green "Neovim configuration set up successfully!"
}

setup_tmux() {
  print_in_purple "Setting up tmux configuration..."
  sleep 2
  brew install tmux
  local tmp_plugins_path="$HOME/.tmux/plugins"
  mkdir -pv "$tmp_plugins_path"
  if [ ! -d "$tmp_plugins_path/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$tmp_plugins_path/tpm"
  fi
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow tmux
  mkdir \
    -p \
    "$HOME/.local/bin" \
    "$HOME/.local/share/man/man1"
  curl \
    -Lo \
    "$HOME/.local/share/man/man1/git-mux.1" \
    "https://raw.githubusercontent.com/benelan/git-mux/stable/bin/man/man1/git-mux.1"
  curl \
    -Lo \
    "$HOME/.local/bin/git-mux" \
    "https://raw.githubusercontent.com/benelan/git-mux/stable/bin/git-mux"
  chmod +x "$HOME/.local/bin/git-mux"
  print_in_green "Tmux configuration set up successfully!"
}

install_additional_tools() {
  print_in_purple "Installing additional development tools..."
  sleep 2
  local packages="$DIR/packages/dev-tools-brew.txt"
  brew bundle --file="$packages"
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
