#!/usr/bin/env bash

setup_gnome() {
  print_in_purple "Installing Gnome..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/gnome.txt"
  xargs -r -a "$packages" sudo dnf install -y
  sudo systemctl enable gdm.service
  print_in_green "✓ Gnome installed successfully!"
}

setup_gnome_settings() {
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

setup_default_apps() {
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
      printf "Hidden=true\n" >> "$local_apps_dir/$app.desktop"
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
  print_in_green "✓ Default apps configured successfully!"
}

setup_hardware_support() {
  print_in_purple "Enabling essential hardware support services..."
  sleep 2
  sudo dnf install -y fprintd libfprint power-profiles-daemon
  sudo systemctl enable power-profiles-daemon.service
  sudo systemctl start power-profiles-daemon.service
  print_in_green "✓ Essential hardware support services enabled!"
}

setup_media_packages() {
  print_in_purple "Installing media and graphics support packages..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/media.txt"
  local fedora_version

  xargs -r -a "$packages" sudo dnf install -y

  fedora_version="$(rpm -E %fedora)"
  sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$fedora_version.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fedora_version.noarch.rpm"
  sudo dnf install -y \
    ffmpeg \
    ffmpeg-libs \
    gstreamer1-libav \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    libavcodec-freeworld \
    mpv

  print_in_green "✓ Media and graphics support packages installed!"
}

setup_fonts() {
  print_in_purple "Installing fonts..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/fonts.txt"
  xargs -r -a "$packages" sudo dnf install -y
  print_in_green "✓ Fonts installed successfully!"
}

setup_ghostty() {
  print_in_purple "Setting up Ghostty..."
  sleep 2
  sudo dnf install -y ghostty
  stow \
    --verbose \
    --dir "$DIR/configs" \
    --target "$HOME" \
    --stow ghostty
  print_in_green "✓ Ghostty set up successfully!"
}

desktop_env() {
  setup_gnome
  setup_ghostty
  setup_gnome_settings
  setup_default_apps
  setup_hardware_support
  setup_media_packages
  setup_fonts
}
