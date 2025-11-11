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
  sudo pacman -Sy --noconfirm --needed openssh
  sudo systemctl enable sshd.service
  sudo systemctl start sshd.service
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

configure_pacman() {
  print_in_purple "Configuring Pacman..."
  sleep 2
  local conf="/etc/pacman.conf"
  if ! grep -q "^Color$" "$conf"; then
    sudo sed -i "s/^#Color$/Color/" "$conf"
  fi
  print_in_green "✓ Pacman configured successfully!"
}

install_yay() {
  print_in_purple "Installing Yay AUR helper..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed fakeroot
  local directory="/tmp/yay-bin"
  if [ -d "$directory" ]; then
    rm -rf "$directory"
  else
    mkdir -p "$directory"
  fi
  git clone https://aur.archlinux.org/yay-bin.git "$directory"
  cd "$directory"
  makepkg -si --noconfirm
  cd "$DIR"
  print_in_green "✓ Yay AUR helper installed successfully!"
}

setup_fish() {
  print_in_purple "Setting up Fish..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed fish
  if ! grep -q "fish" <(getent passwd "$(whoami)"); then
    print_in_purple "Changing login shell to Fish..."
    chsh -s /usr/bin/fish
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
  sudo pacman -Sy --noconfirm --needed bat
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
  configure_pacman
  install_yay
  setup_fish
  setup_bat
}
