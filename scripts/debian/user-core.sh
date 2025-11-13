#!/usr/bin/env bash

setup_stow() {
  print_in_purple "Setting up Stow..."
  sleep 2
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow stow
  print_in_green "✓ Stow set up successfully!"
}

setup_git() {
  print_in_purple "Setting up Git..."
  sleep 2
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow git
  print_in_green "✓ Git set up successfully!"
}

setup_ssh() {
  print_in_purple "Setting up SSH..."
  sleep 2
  sudo apt install -yy openssh-server
  sudo systemctl enable ssh.service
  sudo systemctl start ssh.service
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
    print_in_yellow "⚠ SSH key not found, skipping"
  fi
  print_in_green "✓ SSH set up successfully!"
}

setup_fish() {
  print_in_purple "Setting up Fish..."
  sleep 2
  sudo apt install -yy fish
  if ! grep -q "fish" <(getent passwd "$(whoami)"); then
    print_in_purple "Changing login shell to Fish..."
    sudo chsh -s /usr/bin/fish $USER
  else
    print_in_yellow "⚠ Default shell already set to Fish, skipping"
  fi
  mkdir -pv "$XDG_CONFIG_HOME/fish/completions"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow fish
  print_in_green "✓ Fish set up successfully!"
}

setup_bat() {
  print_in_purple "Setting up Bat..."
  sleep 2
  sudo apt install -yy bat
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow bat
  print_in_green "✓ Bat set up successfully!"
}

user_core() {
  setup_stow
  setup_git
  setup_ssh
  setup_fish
  setup_bat
}
