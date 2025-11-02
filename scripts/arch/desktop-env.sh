#!/usr/bin/env bash

install_gnome() {
  print_in_purple "Installing Gnome..."
  sleep 2
  local packages="$DIR/packages/$OS/gnome.txt"
  sudo pacman -Sy --noconfirm --needed - < "$packages"
  sudo systemctl enable gdm.service
  print_in_green "✓ Gnome installed successfully!"
}

configure_gnome() {
  print_in_purple "Configuring Gnome..."
  sleep 2
  sudo rm -f /etc/xdg/autostart/org.gnome.Software.desktop

  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface enable-animations false
  gsettings set org.gnome.desktop.interface enable-hot-corners true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag false

  gsettings set org.gnome.desktop.wm.keybindings switch-group []
  gsettings set org.gnome.desktop.wm.keybindings switch-group-backward []
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 6
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.shell.keybindings focus-active-notification []

  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 18
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6
  gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3500

  gsettings set org.gnome.desktop.default-applications.terminal exec "ghostty"
  gsettings set org.gnome.nautilus.preferences default-folder-viewer "list-view"
  gsettings set org.gnome.nautilus.preferences default-sort-order "name"
  gsettings set org.gnome.nautilus.preferences show-hidden-files true
  gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true

  print_in_green "✓ Gnome configured successfully!"
}

setup_gnome_extensions() {
  print_in_purple "Setting up gnome extensions..."
  sleep 2
  yay -Sy --noconfirm --needed gnome-extensions-cli
  gext install \
    battery-usage-wattmeter@halfmexicanhalfamazing.gmail.com \
    firefox-profiles@arnaud.work \
    fw-fanctrl-revived@willow.sh \
    mullvadindicator@pobega.github.com \
    nightthemeswitcher@romainvigier.fr \
    space-bar@luchrioh \
    tactile@lundal.io
  dconf load "/org/gnome/shell/extensions/" < "$DIR/misc/dconf/org-gnome-shell-extensions.conf"
  print_in_green "✓ Gnome extenstions set up successfully!"
}

configure_default_apps() {
  print_in_purple "Configuring default apps..."
  sleep 2
  local system_apps_dir="/usr/share/applications"
  local local_apps_dir="$XDG_DATA_HOME/applications"
  local apps=("avahi-discover" "bssh" "bvnc" "qv4l2" "qvidcap")
  mkdir -p "$local_apps_dir"
  for app in "${apps[@]}"; do
    local app_path="$system_apps_dir/$app.desktop"
    if [ -f "$app_path" ]; then
      cp "$app_path" "$local_apps_dir/"
      echo "Hidden=true" >> "$local_apps_dir/$app.desktop"
    fi
  done
  xdg-mime default firefox.desktop text/html
  xdg-mime default org.gnome.Evince.desktop application/pdf
  xdg-mime default org.gnome.loupe.desktop image/bmp
  xdg-mime default org.gnome.loupe.desktop image/gif
  xdg-mime default org.gnome.loupe.desktop image/jpg
  xdg-mime default org.gnome.loupe.desktop image/jpeg
  xdg-mime default org.gnome.loupe.desktop image/png
  xdg-mime default org.gnome.loupe.desktop image/svg+xml
  xdg-mime default org.gnome.loupe.desktop image/tiff
  xdg-mime default transmission-gtk.desktop application/x-bittorrent
  xdg-mime default transmission-gtk.desktop x-scheme-handler/magnet
  print_in_green "✓ Default apps configured successfully!"
}

enable_hardware_support() {
  print_in_purple "Enabling essential hardware support services..."
  sleep 2
  sudo pacman -S --noconfirm --needed \
    fprintd libfprint power-profiles-daemon
  sudo systemctl enable power-profiles-daemon.service
  sudo systemctl start power-profiles-daemon.service
  print_in_green "✓ Essential hardware support services enabled!"
}

install_media_packages() {
  print_in_purple "Installing media and graphics support packages..."
  sleep 2
  local packages="$DIR/packages/$OS/media.txt"
  sudo pacman -Sy --noconfirm --needed - < "$packages"
  print_in_green "✓ Media and graphics support packages installed!"
}

install_fonts() {
  print_in_purple "Installing fonts..."
  sleep 2
  local packages="$DIR/packages/$OS/fonts.txt"
  sudo pacman -Sy --noconfirm --needed - < "$packages"
  print_in_green "✓ Fonts installed successfully!"
}

setup_terminal() {
  print_in_purple "Setting up Ghostty..."
  sleep 2
  sudo pacman -Sy --noconfirm --needed ghostty
  local config_path="$XDG_CONFIG_HOME/ghostty/config"
  mkdir -pv "$XDG_CONFIG_HOME/ghostty/themes"
  if [ -f "$config_path" ]; then
    rm -f "$config_path"
  fi
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ghostty
  print_in_green "✓ Ghostty set up successfully!"
}

desktop_env() {
  install_gnome
  configure_gnome
  setup_gnome_extensions
  configure_default_apps
  enable_hardware_support
  install_media_packages
  install_fonts
  setup_terminal
}
