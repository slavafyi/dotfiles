#!/usr/bin/env bash

_verify_docker_gpg_key() {
  local key_url="https://download.docker.com/linux/fedora/gpg"
  local expected_fingerprint="060A61C51B558A7F742B77AAC52FEB6B621E9F35"
  local key_file
  local fingerprint

  key_file=$(mktemp)
  if ! curl -fsSL "$key_url" -o "$key_file"; then
    print_in_red "✗ Could not download Docker GPG key"
    rm -f "$key_file"
    return 1
  fi

  fingerprint=$(gpg --show-keys --with-colons "$key_file" 2> /dev/null | awk -F: '$1 == "fpr" { print $10; exit }')
  if [[ $fingerprint != "$expected_fingerprint" ]]; then
    print_in_red "✗ Docker GPG key fingerprint mismatch"
    rm -f "$key_file"
    return 1
  fi

  sudo rpm --import "$key_file"
  rm -f "$key_file"
}

setup_mise() {
  print_in_purple "Setting up Mise..."
  sleep 2

  if ! command -v mise > /dev/null 2>&1; then
    if ! sudo dnf install -y mise; then
      sudo dnf install -y dnf-plugins-core
      if ! sudo dnf config-manager addrepo --from-repofile="https://mise.jdx.dev/rpm/mise.repo" &&
        ! sudo dnf config-manager --add-repo "https://mise.jdx.dev/rpm/mise.repo"; then
        print_in_yellow "⚠ Mise repo setup failed; skipping mise setup"
        return 0
      fi
      sudo dnf install -y mise || {
        print_in_yellow "⚠ Mise package not available after repo setup; skipping mise setup"
        return 0
      }
    fi
  fi

  sudo dnf install -y stow
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow mise

  if command -v fish > /dev/null 2>&1 && command -v mise > /dev/null 2>&1; then
    mkdir -p "$XDG_CONFIG_HOME/fish/completions"
    mise completion fish > "$XDG_CONFIG_HOME/fish/completions/mise.fish"
  fi

  if command -v mise > /dev/null 2>&1; then
    mise trust --all --yes
    mise install
    mise ls
  fi

  print_in_green "✓ Mise set up successfully!"
}

setup_docker() {
  print_in_purple "Setting up Docker..."
  sleep 2

  if command -v docker > /dev/null 2>&1; then
    print_in_yellow "⚠ Docker already installed, skipping"
    return 0
  fi

  local repo_file="/etc/yum.repos.d/docker-ce.repo"

  sudo dnf install -y curl dnf-plugins-core gnupg2
  if ! _verify_docker_gpg_key; then
    print_in_yellow "⚠ Docker GPG verification failed; skipping Docker setup"
    return 0
  fi

  if [ ! -f "$repo_file" ]; then
    if ! sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo &&
      ! sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo; then
      print_in_yellow "⚠ Docker repo setup failed; skipping Docker setup"
      return 0
    fi
  fi

  if sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
  else
    print_in_yellow "⚠ Docker CE installation failed"
    return 0
  fi

  sudo usermod -aG docker "$USER"
  print_in_yellow "⚠ You may need to relogin for docker group changes to apply"

  print_in_green "✓ Docker set up successfully!"
}

setup_neovim() {
  print_in_purple "Setting up Neovim..."
  sleep 2

  sudo dnf install -y neovim stow
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

  sudo dnf install -y git stow tmux
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

setup_github() {
  print_in_purple "Setting up GitHub CLI..."
  sleep 2

  if ! command -v gh > /dev/null 2>&1; then
    if ! sudo dnf install -y gh; then
      print_in_yellow "⚠ GitHub CLI package unavailable; skipping"
      return 0
    fi
  fi

  print_in_green "✓ GitHub CLI set up successfully!"
}

setup_heroku() {
  print_in_purple "Setting up Heroku CLI..."
  sleep 2

  if command -v heroku > /dev/null 2>&1; then
    print_in_yellow "⚠ Heroku CLI already installed, skipping"
    return 0
  fi

  if sudo dnf install -y heroku-cli || sudo dnf install -y heroku; then
    print_in_green "✓ Heroku CLI set up successfully!"
    return 0
  fi

  print_in_yellow "⚠ Heroku CLI not available from safe default sources; skipping"
}

setup_lazygit() {
  print_in_purple "Setting up Lazygit..."
  sleep 2

  if command -v lazygit > /dev/null 2>&1; then
    print_in_yellow "⚠ Lazygit already installed, skipping"
    return 0
  fi

  if sudo dnf install -y lazygit; then
    print_in_green "✓ Lazygit set up successfully!"
    return 0
  fi

  print_in_yellow "⚠ Lazygit package unavailable from safe Fedora sources; skipping"
}

setup_lazydocker() {
  print_in_purple "Setting up Lazydocker..."
  sleep 2

  if command -v lazydocker > /dev/null 2>&1; then
    print_in_yellow "⚠ Lazydocker already installed, skipping"
    return 0
  fi

  if ! command -v docker > /dev/null 2>&1; then
    print_in_yellow "⚠ Docker not installed, skipping lazydocker"
    return 0
  fi

  if sudo dnf install -y lazydocker; then
    print_in_green "✓ Lazydocker set up successfully!"
    return 0
  fi

  print_in_yellow "⚠ Lazydocker package unavailable and no safe installer path is configured"
}

setup_fzf() {
  print_in_purple "Setting up Fzf..."
  sleep 2

  if command -v fzf > /dev/null 2>&1; then
    print_in_yellow "⚠ Fzf already installed, skipping"
    return 0
  fi

  if ! sudo dnf install -y fzf; then
    print_in_yellow "⚠ Fzf package unavailable, skipping"
    return 0
  fi

  print_in_green "✓ Fzf set up successfully!"
}

setup_sesh() {
  print_in_purple "Setting up sesh..."
  sleep 2

  if command -v sesh > /dev/null 2>&1; then
    print_in_yellow "⚠ sesh already installed, skipping"
    return 0
  fi

  if sudo dnf install -y sesh; then
    print_in_green "✓ sesh set up successfully!"
    return 0
  fi

  print_in_yellow "⚠ sesh package unavailable from safe Fedora sources; skipping"
}

setup_opencode() {
  print_in_purple "Setting up OpenCode..."
  sleep 2

  if command -v opencode > /dev/null 2>&1; then
    print_in_yellow "⚠ OpenCode already installed, skipping"
  elif sudo dnf install -y opencode; then
    print_in_yellow "⚠ Fedora package installed OpenCode"
  elif command -v pnpm > /dev/null 2>&1; then
    pnpm install -g opencode-ai
  else
    print_in_yellow "⚠ OpenCode unavailable and pnpm is not installed; skipping"
    return 0
  fi

  sudo dnf install -y stow
  stow \
    --verbose \
    --no-folding \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow opencode

  print_in_green "✓ OpenCode set up successfully!"
}

setup_pi() {
  print_in_purple "Setting up Pi coding agent..."
  sleep 2

  if ! command -v pnpm > /dev/null 2>&1; then
    print_in_yellow "⚠ pnpm not available; skipping Pi setup"
    return 0
  fi

  pnpm install -g @mariozechner/pi-coding-agent
  sudo dnf install -y stow
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

  xargs -r -a "$packages" sudo dnf install -y

  if command -v cargo > /dev/null 2>&1 && command -v cargo-binstall > /dev/null 2>&1; then
    print_in_purple "Installing cargo packages..."
    cargo binstall stylua usage-cli
  elif command -v cargo > /dev/null 2>&1; then
    print_in_yellow "⚠ cargo-binstall unavailable, skipping cargo package installs"
  fi

  sudo dnf install -y stow
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
  sudo dnf install -y stow
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
  sudo dnf install -y stow
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
  setup_github
  setup_heroku
  setup_lazygit
  setup_lazydocker
  setup_fzf
  setup_sesh
  setup_opencode
  setup_pi
  setup_agents
  setup_bins
  setup_dev_tools
}
