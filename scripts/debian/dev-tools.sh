#!/usr/bin/env bash

setup_mise() {
  print_in_purple "Setting up Mise..."
  sleep 2
  if ! command -v mise > /dev/null 2>&1; then
    local arch=$(dpkg --print-architecture)
    sudo install -dm 755 /etc/apt/keyrings
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$arch] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
  fi
  sudo apt update
  sudo apt install -yy mise autoconf libncurses-dev libssl-dev libyaml-dev zlib1g-dev
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow mise
  if command -v fish > /dev/null 2>&1; then
    mkdir -p "$XDG_CONFIG_HOME/fish/completions"
    mise completion fish > "$XDG_CONFIG_HOME/fish/completions/mise.fish"
  fi
  mise install
  mise ls
  print_in_green "✓ Mise set up successfully!"
}

setup_docker() {
  print_in_purple "Setting up Docker..."
  sleep 2
  if ! command -v docker > /dev/null 2>&1; then
    local arch=$(dpkg --print-architecture)
    local key_path=/etc/apt/keyrings/docker.gpg
    local url=https://download.docker.com/linux/debian
    source /etc/os-release
    sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
    sudo apt update
    sudo apt install -yy ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL "$url/gpg" -o $key_path
    sudo chmod a+r $key_path
    echo "deb [arch=$arch signed-by=$key_path] $url $VERSION_CODENAME stable" |
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -yy docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    sudo usermod -aG docker $USER
  else
    sudo apt update
    sudo apt install -yy docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi
  print_in_green "✓ Docker set up successfully!"
}

setup_neovim() {
  print_in_purple "Setting up Neovim..."
  sleep 2
  local temp_path=/tmp/neovim-src
  sudo apt update
  sudo apt install -yy ninja-build gettext cmake unzip curl build-essential git
  if [ ! -d "$temp_path" ]; then
    git clone https://github.com/neovim/neovim.git $temp_path
  else
    cd $temp_path
    rm -rf build/
    git pull
  fi
  cd $temp_path
  make CMAKE_BUILD_TYPE=Release
  sudo make install
  cd "$DIR"
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
  sudo apt install -yy tmux
  local tmp_plugins_path="$HOME/.tmux/plugins"
  mkdir -pv "$tmp_plugins_path"
  if [ ! -d "$tmp_plugins_path/tpm" ]; then
    print_in_purple "Adding Tmux plugin manager..."
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

setup_github() {
  print_in_purple "Setting up Gihub CLI..."
  sleep 2
  if ! command -v gh > /dev/null 2>&1; then
    local temp_path="$(mktemp)"
    local arch=$(dpkg --print-architecture)
    local key_path=/etc/apt/keyrings/githubcli-archive-keyring.gpg
    local url=https://cli.github.com/packages
    sudo install -dm 755 /etc/apt/keyrings
    wget -nv -O$temp_path "$url/githubcli-archive-keyring.gpg"
    cat $temp_path | sudo tee $key_path > /dev/null
    sudo chmod go+r $key_path
    sudo mkdir -p -m 755 /etc/apt/sources.list.d
    echo "deb [arch=$arch signed-by=$key_path] $url stable main" |
      sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  fi
  sudo apt update
  sudo apt install -yy gh
  print_in_green "✓ Gihub CLI set up successfully!"
}

setup_heroku() {
  print_in_purple "Setting up Heroku CLI..."
  sleep 2
  if ! command -v heroku > /dev/null 2>&1; then
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
  fi
  sudo apt update
  sudo apt install -yy heroku
  print_in_green "✓ Heroku CLI set up successfully!"
}

setup_lazydocker() {
  print_in_purple "Setting up Lazydocker..."
  sleep 2
  if ! command -v docker > /dev/null 2>&1; then
    print_in_yellow "⚠ Docker not installed, skipping"
    return 0
  else
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  fi
  print_in_green "✓ Lazydocker set up successfully!"
}

install_dev_tools() {
  print_in_purple "Installing dev tools..."
  sleep 2
  local packages="$DIR/packages/$OS/dev-tools.txt"
  sudo apt update
  xargs -r -a "$packages" sudo apt install -yy
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
  setup_github
  setup_heroku
  setup_lazydocker
  install_bin_scripts
  install_dev_tools
}
