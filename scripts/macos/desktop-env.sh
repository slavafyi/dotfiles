#!/usr/bin/env bash

setup_preferences() {
  print_in_purple "Applying system preferences..."
  sleep 2
  local screenshot_folder="$HOME/Pictures/Screenshots"
  mkdir -pv "$screenshot_folder"
  defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true
  defaults write -g InitialKeyRepeat -int 15
  defaults write -g KeyRepeat -int 2
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture location -string "$screenshot_folder"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
  defaults write com.apple.finder _FXSortFoldersFirst -bool true
  defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
  defaults write com.apple.finder NewWindowTarget -string PfHm
  defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  defaults write com.apple.menuextra.clock FlashDateSeparators -bool true
  defaults write com.apple.HIToolbox AppleFnUsageType -int 2
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled -bool false
  defaults write com.apple.TextEdit RichText -bool false
  defaults write com.apple.CloudSubscriptionFeatures.optIn 545129924 -bool false
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
  defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool false
  defaults write com.apple.airplay showInMenuBarIfPresent -bool false
  defaults write com.apple.airplay "NSStatusItem Visible NowPlaying" -bool false
  defaults write com.apple.menuextra.clock ShowDate -int 0
  defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
  defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
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
  mkdir -pv "$HOME/.config/ghostty/themes"
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ghostty
  print_in_green "Ghostty configuration set up successfully!"
}

setup_keymaps() {
  print_in_purple "Setting up keymaps configuration..."
  sleep 2
  brew install --cask karabiner-elements
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow keymaps
  print_in_green "Keymaps configuration set up successfully!"
}

desktop_env() {
  setup_preferences
  install_apps
  setup_fonts
  setup_terminal
  setup_keymaps
}
