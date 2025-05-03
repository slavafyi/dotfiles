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
  sudo pacman -Sy --noconfirm --needed openssh
  sudo systemctl enable sshd.service
  sudo systemctl start sshd.service
  mkdir -pv "$HOME/.ssh"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ssh
  print_in_green "SSH settings configured successfully!"
}

setup_pacman() {
  print_in_purple "Configuring pacman settings..."
  sleep 2
  local conf="/etc/pacman.conf"
  if ! grep -q "^Color$" "$conf"; then
    sudo sed -i "s/^#Color$/Color/" "$conf"
  fi
  print_in_green "Pacman settings configured successfully!"
}

setup_yay() {
  print_in_purple "Installing Yay AUR helper..."
  sleep 2
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
  print_in_green "Yay AUR helper installed successfully!"
}

setup_fish_shell() {
  print_in_purple "Installing Fish shell..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed fish
  if ! grep -q "fish" <(getent passwd "$(whoami)"); then
    print_in_purple "Changing login shell to Fish..."
    chsh -s /usr/bin/fish
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

setup_starship_prompt() {
  print_in_purple "Installing starhip prompt..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed starship
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow starship
  print_in_green "Starship prompt installed successfully!"
}

user_core() {
  setup_stow
  setup_git
  setup_ssh
  setup_pacman
  setup_yay
  setup_fish_shell
  setup_starship_prompt
}
