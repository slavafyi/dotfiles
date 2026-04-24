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
  mise trust --all --yes
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
  print_in_green "✓ Tmux set up successfully!"
}

setup_opencode() {
  print_in_purple "Setting up OpenCode..."
  sleep 2
  brew install anomalyco/tap/opencode
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow opencode
  print_in_green "✓ OpenCode set up successfully!"
}

setup_pi() {
  print_in_purple "Setting up Pi coding agent..."
  sleep 2
  pnpm install -g @mariozechner/pi-coding-agent
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow pi
  print_in_green "✓ Pi coding agent set up successfully!"
}

setup_dev_tools() {
  print_in_purple "Installing dev tools..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/dev-tools.txt"
  brew bundle --file="$packages"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow tools
  print_in_green "✓ Dev tools installed successfully!"
}

setup_bins() {
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

setup_agents() {
  print_in_purple "Installing agents..."
  sleep 2
  mkdir -pv "$HOME/.agents"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow agents
  print_in_green "✓ Agents installed successfully!"
}

dev_tools() {
  setup_mise
  setup_docker
  setup_neovim
  setup_tmux
  setup_opencode
  setup_pi
  setup_agents
  setup_bins
  setup_dev_tools
}
