#!/usr/bin/env bash

install_fonts() {
  print_in_purple "Installing Nerd Fonts..."
  sleep 2
  local packages="$DIR/packages/$OS/fonts.txt"
  local fonts_dir="$XDG_DATA_HOME/fonts"
  local temp_path=/tmp/
  sudo apt install -yy fontconfig
  mkdir -p "$fonts_dir"
  while IFS= read -r font || [[ -n $font ]]; do
    [[ -z $font || $font =~ ^# ]] && continue
    local font_dir="$fonts_dir/$font"
    if [ ! -d "$font_dir" ]; then
      print_in_purple "Installing $font..."
      mkdir -p "$font_dir"
      cd "$temp_path"
      wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
      unzip -q "${font}.zip" -d "$font_dir"
      rm "${font}.zip"
      fc-cache -f "$font_dir" 2> /dev/null || true
      cd "$DIR"
    else
      print_in_yellow "✓ $font already installed, skipping"
    fi
  done < "$packages"
  print_in_green "✓ Fonts installed successfully!"
}

desktop_env() {
  install_fonts
}
