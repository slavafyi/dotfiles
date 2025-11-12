#!/usr/bin/env bash

setup_mise() {
  print_in_purple "Setting up Mise..."
  sleep 2
  brew install mise usage libyaml
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow mise
  mise completion fish > "$XDG_CONFIG_HOME/fish/completions/mise.fish"
  mise install
  mise ls
  print_in_green "✓ Mise set up successfully!"
}

setup_docker() {
  print_in_purple "Setting up Docker..."
  sleep 2
  brew install --cask orbstack
  docker completion fish > "$XDG_CONFIG_HOME/fish/completions/docker.fish"
  orb completion fish > "$XDG_CONFIG_HOME/fish/completions/orb.fish"
  print_in_green "✓ Docker set up successfully!"
}

setup_neovim() {
  print_in_purple "Setting up Neovim..."
  sleep 2
  brew install neovim
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow neovim
  print_in_green "✓ Neovim set up successfully!"
}

setup_tmux() {
  print_in_purple "Setting up Tmux..."
  sleep 2
  brew install tmux
  local tmp_plugins_path="$HOME/.tmux/plugins"
  mkdir -pv "$tmp_plugins_path"
  if [ ! -d "$tmp_plugins_path/tpm" ]; then
    print_in_purple "Adding Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$tmp_plugins_path/tpm"
  fi
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow tmux
  mkdir \
    -p \
    "$XDG_BIN_HOME" \
    "$XDG_DATA_HOME/man/man1"
  curl \
    -Lo \
    "$XDG_DATA_HOME/man/man1/git-mux.1" \
    "https://raw.githubusercontent.com/benelan/git-mux/stable/bin/man/man1/git-mux.1"
  curl \
    -Lo \
    "$XDG_BIN_HOME/git-mux" \
    "https://raw.githubusercontent.com/benelan/git-mux/stable/bin/git-mux"
  chmod +x "$XDG_BIN_HOME/git-mux"
  print_in_green "✓ Tmux set up successfully!"
}

install_dev_tools() {
  print_in_purple "Installing dev tools..."
  sleep 2
  local packages="$DIR/packages/$OS/dev-tools.txt"
  brew bundle --file="$packages"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow tools
  print_in_green "✓ Dev tools installed successfully!"
}

install_bin_scripts() {
  print_in_purple "Installing bin scripts..."
  sleep 2
  mkdir -pv "$XDG_BIN_HOME"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow bin
  print_in_green "✓ Bin scripts installed successfully!"
}

dev_tools() {
  setup_mise
  setup_docker
  setup_neovim
  setup_tmux
  install_bin_scripts
  install_dev_tools
}
