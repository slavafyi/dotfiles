#!/usr/bin/env bash

setup_preferences() {
  print_in_purple "Applying system preferences..."
  sleep 2
  defaults write -g InitialKeyRepeat -int 10
  defaults write -g KeyRepeat -int 1
  defaults write com.apple.dock "autohide" -bool "true"
  defaults write com.apple.dock "show-recents" -bool "false"
  defaults write com.apple.screencapture "disable-shadow" -bool "true"
  defaults write com.apple.screencapture "location" -string "$HOME/Pictures/Screenshots"
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
  defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"
  defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
  defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true"
  defaults write com.apple.HIToolbox AppleFnUsageType -int "2"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"
  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled -bool "false"
  defaults write com.apple.TextEdit "RichText" -bool "false"
  defaults write com.apple.CloudSubscriptionFeatures.optIn "545129924" -bool "false"
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"
  chflags nohidden "$HOME/Library"
  killall Dock
  killall SystemUIServer
  killall Finder
  print_in_green "System preferences applied successfully!"
}

install_apps() {
  print_in_purple "Installing apps..."
  sleep 2
  local packages="$DIR/packages/apps-brew.txt"
  brew bundle --file="$packages"
  print_in_green "Apps installed successfully!"
}

setup_fonts() {
  print_in_purple "Installing additional fonts..."
  sleep 2
  local packages="$DIR/packages/fonts-brew.txt"
  brew bundle --file="$packages"
  print_in_green "Additional fonts installed successfully!"
}

setup_terminal() {
  print_in_purple "Setting up ghostty configuration..."
  sleep 2
  brew install --cask ghostty
  local config_path="$HOME/.config/ghostty/config"
  mkdir -pv "$HOME/.config/ghostty/themes"
  if [ -f "$config_path" ]; then
    rm -f "$config_path"
  fi
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ghostty
  print_in_green "Ghostty configuration set up successfully!"
}

desktop_env() {
  setup_preferences
  install_apps
  setup_fonts
  setup_terminal
}
