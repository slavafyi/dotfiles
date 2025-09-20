#!/usr/bin/env bash

setup_stow() {
  print_in_purple "Setting up stow configuration..."
  sleep 2
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow stow
  print_in_green "Stow configuration set up successfully!"
}

setup_git() {
  print_in_purple "Configuring Git settings..."
  sleep 2
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow git
  print_in_green "Git settings configured successfully!"
}

setup_ssh() {
  print_in_purple "Configuring SSH settings..."
  sleep 2
  mkdir -pv "$HOME/.ssh"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ssh
  eval "$(ssh-agent -s)"
  local ssh_key="$HOME/.ssh/id_ed25519"
  if [ -f "$ssh_key" ]; then
    ssh-add "$ssh_key"
  else
    print_in_yellow "SSH key not found. Skipping key adding."
  fi
  print_in_green "SSH settings configured successfully!"
}

setup_gpg() {
  print_in_purple "Configuring GPG settings..."
  sleep 2
  brew install pinentry-mac
  local conf="$HOME/.gnupg/gpg-agent.conf"
  local pinentry_path="$(which pinentry-mac)"
  mkdir -pv "$HOME/.gnupg"
  touch "$conf"
  if grep -q "^pinentry-program " "$conf"; then
    sed -i.bak "s|^pinentry-program .*|pinentry-program $pinentry_path|" "$conf"
  else
    echo "pinentry-program $pinentry_path" >> "$conf"
  fi
  gpgconf --reload gpg-agent
  print_in_green "GPG settings configured successfully!"
}

setup_fish_shell() {
  print_in_purple "Installing Fish shell..."
  sleep 2
  brew install fish
  local conf="/etc/shells"
  local bin="/opt/homebrew/bin/fish"
  if ! grep -q "fish" "$conf"; then
    sudo sh -c 'echo "$bin" >> "/etc/shells"'
  fi
  if ! grep -q "fish" <(dscl . -read /Users/"$(whoami)" UserShell); then
    print_in_purple "Changing login shell to Fish..."
    chsh -s "$bin"
  else
    print_in_yellow "Default shell already set to Fish."
  fi
  mkdir -pv "$HOME/.config/fish/conf.d"
  mkdir -pv "$HOME/.config/fish/completions"
  mkdir -pv "$HOME/.config/fish/functions"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow fish
  print_in_green "Fish shell installed successfully!"
}

user_core() {
  setup_stow
  setup_git
  setup_ssh
  setup_gpg
  setup_fish_shell
}
