#!/usr/bin/env bash

_set_gsettings() {
  local schema="$1"
  local key="$2"
  shift 2

  if ! gsettings set "$schema" "$key" "$@"; then
    print_in_yellow "⚠ Failed to set $schema $key"
    return 1
  fi
}

setup_gnome() {
  print_in_purple "Installing GNOME..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/gnome.txt"
  local package
  local failed_install=0

  while IFS= read -r package || [[ -n $package ]]; do
    [[ -z $package || $package =~ ^# ]] && continue
    if ! sudo dnf install -y "$package"; then
      failed_install=1
      print_in_yellow "⚠ Could not install GNOME package '$package'; continuing"
    fi
  done < "$packages"

  if [[ $failed_install -ne 0 ]]; then
    print_in_red "✗ GNOME install completed with errors"
    return 1
  fi

  sudo systemctl enable gdm.service
  print_in_green "✓ GNOME installed successfully!"
}

setup_gnome_settings() {
  print_in_purple "Configuring GNOME..."
  sleep 2
  if ! command -v gsettings > /dev/null 2>&1; then
    print_in_yellow "⚠ gsettings not available, skipping GNOME settings"
    return 0
  fi

  local failed_settings=0
  sudo rm -f /etc/xdg/autostart/org.gnome.Software.desktop

  if command -v ghostty > /dev/null 2>&1; then
    _set_gsettings org.gnome.desktop.default-applications.terminal exec "ghostty" || failed_settings=1
  else
    print_in_yellow "⚠ Ghostty unavailable, skipping default terminal setting"
  fi

  _set_gsettings org.gnome.desktop.interface clock-show-date true || failed_settings=1
  _set_gsettings org.gnome.desktop.interface clock-show-weekday true || failed_settings=1
  _set_gsettings org.gnome.desktop.interface enable-animations false || failed_settings=1
  _set_gsettings org.gnome.desktop.interface enable-hot-corners true || failed_settings=1
  _set_gsettings org.gnome.desktop.interface show-battery-percentage true || failed_settings=1
  _set_gsettings org.gnome.desktop.peripherals.touchpad tap-and-drag false || failed_settings=1

  _set_gsettings org.gnome.desktop.wm.keybindings switch-group [] || failed_settings=1
  _set_gsettings org.gnome.desktop.wm.keybindings switch-group-backward [] || failed_settings=1
  _set_gsettings org.gnome.desktop.wm.preferences num-workspaces 6 || failed_settings=1
  _set_gsettings org.gnome.mutter dynamic-workspaces false || failed_settings=1
  _set_gsettings org.gnome.shell.keybindings focus-active-notification [] || failed_settings=1

  _set_gsettings org.gnome.settings-daemon.plugins.color night-light-enabled true || failed_settings=1
  _set_gsettings org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true || failed_settings=1
  _set_gsettings org.gnome.settings-daemon.plugins.color night-light-schedule-from 18 || failed_settings=1
  _set_gsettings org.gnome.settings-daemon.plugins.color night-light-schedule-to 6 || failed_settings=1
  _set_gsettings org.gnome.settings-daemon.plugins.color night-light-temperature 3500 || failed_settings=1

  _set_gsettings org.gnome.desktop.wm.preferences titlebar-font "Sans 10" || failed_settings=1
  _set_gsettings org.gnome.desktop.interface gtk-theme "Adwaita-dark" || failed_settings=1
  _set_gsettings org.gnome.desktop.interface icon-theme "Adwaita" || failed_settings=1
  _set_gsettings org.gnome.desktop.interface accent-color "blue" || failed_settings=1
  _set_gsettings org.gnome.nautilus.preferences default-folder-viewer "list-view" || failed_settings=1
  _set_gsettings org.gnome.nautilus.preferences default-sort-order "name" || failed_settings=1
  _set_gsettings org.gnome.nautilus.preferences show-hidden-files true || failed_settings=1
  _set_gsettings org.gtk.gtk4.Settings.FileChooser sort-directories-first true || failed_settings=1

  if [[ $failed_settings -ne 0 ]]; then
    print_in_red "✗ GNOME settings completed with errors"
    return 1
  fi

  print_in_green "✓ GNOME configured successfully!"
}

setup_gnome_extensions() {
  print_in_purple "Setting up GNOME extensions..."
  sleep 2
  print_in_yellow "⚠ Automated GNOME extension installation is limited on Fedora; install website-only extensions manually"
  if command -v dconf > /dev/null 2>&1; then
    if ! dconf load "/org/gnome/shell/extensions/" < "$DIR/misc/dconf/org-gnome-shell-extensions.conf"; then
      print_in_yellow "⚠ Failed to apply GNOME extension dconf settings"
      return 1
    fi
  else
    print_in_yellow "⚠ dconf not available, skipping extension settings"
  fi
}

setup_default_apps() {
  print_in_purple "Configuring default apps..."
  sleep 2
  sudo dnf install -y xdg-utils
  local system_apps_dir="/usr/share/applications"
  local local_apps_dir="$XDG_DATA_HOME/applications"
  local apps=(avahi-discover bssh bvnc qv4l2 qvidcap)

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
  xdg-mime default org.gnome.Evince.desktop application/pdf
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
  local pkg

  xargs -r -a "$packages" sudo dnf install -y

  fedora_version="$(rpm -E %fedora)"
  if ! sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$fedora_version.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fedora_version.noarch.rpm"; then
    print_in_yellow "⚠ RPM Fusion repo setup failed; skipping enhanced codecs"
    print_in_green "✓ Media and graphics support packages installed!"
    return 0
  fi

  for pkg in ffmpeg ffmpeg-libs gstreamer1-plugins-bad-freeworld gstreamer1-libav gstreamer1-plugins-ugly libavcodec-freeworld mpv vlc; do
    if ! sudo dnf install -y "$pkg"; then
      print_in_yellow "⚠ Could not install $pkg from RPM Fusion; continuing"
    fi
  done

  print_in_green "✓ Media and graphics support packages installed!"
}

setup_fonts() {
  print_in_purple "Installing fonts..."
  sleep 2
  local packages="$DIR/misc/packages/$OS/fonts.txt"

  xargs -r -a "$packages" sudo dnf install -y
  fc-cache -f > /dev/null 2>&1 || true
  print_in_green "✓ Fonts installed successfully!"
}

setup_ghostty() {
  print_in_purple "Setting up Ghostty..."
  sleep 2

  if command -v ghostty > /dev/null 2>&1; then
    print_in_yellow "⚠ Ghostty already installed, skipping package install"
    sudo dnf install -y stow
    stow \
      --verbose \
      --dir "$DIR/configs" \
      --target "$HOME" \
      --stow ghostty
    return 0
  fi

  if sudo dnf install -y ghostty stow > /dev/null 2>&1; then
    stow \
      --verbose \
      --dir "$DIR/configs" \
      --target "$HOME" \
      --stow ghostty
    print_in_green "✓ Ghostty set up successfully!"
    return 0
  fi

  print_in_yellow "⚠ Ghostty unavailable from default Fedora sources; skipping default terminal setup"
}

desktop_env() {
  setup_gnome
  setup_ghostty
  setup_gnome_settings
  setup_gnome_extensions
  setup_default_apps
  setup_hardware_support
  setup_media_packages
  setup_fonts
}
