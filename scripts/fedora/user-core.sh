#!/usr/bin/env bash

setup_stow() {
  print_in_purple "Setting up Stow..."
  sleep 2
  sudo dnf install -y stow
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
  sudo dnf install -y git stow
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
  sudo dnf install -y openssh-server stow
  sudo systemctl enable sshd.service
  sudo systemctl start sshd.service
  mkdir -pv "$HOME/.ssh"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ssh
  if command -v ssh-agent > /dev/null 2>&1 && command -v ssh-add > /dev/null 2>&1; then
    eval "$(ssh-agent -s)"
    local ssh_key="$HOME/.ssh/id_ed25519"
    if [ -f "$ssh_key" ]; then
      ssh-add "$ssh_key"
    else
      print_in_yellow "⚠ SSH key not found, skipping"
    fi
  fi
  print_in_green "✓ SSH set up successfully!"
}

setup_pacman() {
  print_in_purple "Configuring Pacman..."
  sleep 2
  print_in_yellow "⚠ Pacman is Arch-specific; Fedora uses DNF, skipping"
}

setup_yay() {
  print_in_purple "Installing Yay AUR helper..."
  sleep 2
  print_in_yellow "⚠ Yay/AUR is Arch-specific; Fedora uses DNF and per-tool safe sources, skipping"
}

setup_env() {
  print_in_purple "Setting up environment..."
  sleep 2
  sudo dnf install -y stow
  mkdir -p "$XDG_CONFIG_HOME/env"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow env
  local out="$XDG_CONFIG_HOME/env/local.sh"
  : > "$out"
  printf "export DOTFILES=%s\n" "$DIR" >> "$out"
  render_env
  print_in_green "✓ Environment set up successfully!"
}

setup_fish() {
  print_in_purple "Setting up Fish..."
  sleep 2
  local fish_bin="/usr/bin/fish"

  sudo dnf install -y fish stow
  local current_shell
  current_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
  if [[ $current_shell != "$fish_bin" ]]; then
    print_in_purple "Changing login shell to Fish..."
    sudo chsh -s "$fish_bin" "$USER"
  else
    print_in_yellow "⚠ Default shell already set to Fish, skipping"
  fi
  mkdir -pv "$XDG_CONFIG_HOME/fish/completions"
  mkdir -pv "$XDG_CONFIG_HOME/fish/conf.d"
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
  sudo dnf install -y bat stow
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow bat
  print_in_green "✓ Bat set up successfully!"
}

user_core() {
  setup_env
  setup_stow
  setup_git
  setup_ssh
  setup_pacman
  setup_yay
  setup_fish
  setup_bat
}
