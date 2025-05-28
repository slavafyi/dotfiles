#!/usr/bin/env bash

add_repositories() {
  print_in_purple "Adding repositories..."

  # RPM Fusion & Terra
  sudo dnf install --assumeyes \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install --assumeyes --nogpgcheck --repofrompath \
    "terra,https://repos.fyralabs.com/terra$releasever" terra-release
  sudo dnf group upgrade --assumeyes core

  # Enable copr
  sudo dnf --assumeyes copr enable atim/lazygit
  sudo dnf --assumeyes copr enable blakegardner/xremap

  # Enable Third Party Repositories
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  print_in_green "Repositories added successfully!"
  sleep 2
}

add_packages() {
  print_in_purple "Installing packages..."

  # Common
  sudo dnf --assumeyes install \
    cmake containerd curl docker-cli fd-find gcc gettext git \
    glibc-gconv-extra gpg make ninja-build ripgrep stow unzip wl-clipboard

  # Media Codecs
  sudo dnf swap --assumeyes --allowerasing ffmpeg-free ffmpeg # Switch to full FFMPEG.
  sudo dnf group upgrade --assumeyes multimedia
  sudo dnf group install --assumeyes sound-and-video # Installs useful Sound and Video complement packages.

  # H/W Video Decoding
  sudo dnf install --assumeyes ffmpeg-libs libva libva-utils
  sudo dnf swap --assumeyes mesa-va-drivers mesa-va-drivers-freeworld
  sudo dnf swap --assumeyes mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

  # OpenH264 for Firefox
  sudo dnf install --assumeyes openh264 gstreamer1-plugin-openh264 mozilla-openh26
  sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

  # Gnome
  sudo dnf install --assumeyes gnome-tweaks python3-pip
  sudo flatpak install --assumeyes flathub org.gnome.Extensions
  python -m pip install --upgrade gnome-extensions-cli
  gext install \
    mullvadindicator@pobega.github.com \
    space-bar@luchrioh \
    tactile@lundal.io \
    nightthemeswitcher@romainvigier.fr \
    xremap@k0kubun.com

  # Apps / TUI
  sudo dnf --assumeyes install \
    bat btop fastfetch fzf gh ghostty google-chrome-stable \
    lazygit lpf-spotify-client nextcloud-client \
    telegram-desktop transmission tmux vlc xremap-gnome zed

  sudo flatpak install --assumeyes flathub \
    org.localsend.localsend_app \
    org.getoutline.OutlineClient \
    org.getoutline.OutlineManager \
    com.slack.Slack \
    com.bitwarden.desktop \
    md.obsidian.Obsidian

  print_in_green "Packages installed successfully!"
  sleep 2
}

system_settings() {
  print_in_purple "Configuring system settings..."

  sudo rm -f \
    /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
  sudo timedatectl set-local-rtc false
  sudo timedatectl set-timezone Europe/Moscow
  sudo rm /etc/xdg/autostart/org.gnome.Software.desktop
  # Disabling it can decrease the boot time
  sudo systemctl disable NetworkManager-wait-online.service
  # Fix issue with Laggy or stuttering touchpad
  sudo grubby --update-kernel=ALL --args="amdgpu.dcdebugmask=0x10"

  print_in_green "System settings configured successfully!"
  sleep 2
}

user_settings() {
  print_in_purple "Configuring GNOME settings..."

  gsettings set org.gnome.desktop.interface clock-show-date true
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface enable-animations false
  gsettings set org.gnome.desktop.interface enable-hot-corners true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag false

  WORKSPACE_NUMBER=6

  for ((i = 1; i <= WORKSPACE_NUMBER; i++)); do
    gsettings set org.gnome.shell.keybindings switch-to-application-$i []
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
  done

  gsettings set org.gnome.desktop.wm.preferences num-workspaces $WORKSPACE_NUMBER
  gsettings set org.gnome.mutter dynamic-workspaces false

  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 18
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6
  gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3500

  dconf load /org/gnome/shell/extensions/ < ./misc/dconf/org-gnome-shell-extensions.conf

  print_in_green "GNOME settings configured successfully!"
  sleep 2
}

system_update() {
  print_in_purple "Updating the system..."

  sudo dnf upgrade --assumeyes --refresh
  sudo flatpak update --assumeyes

  print_in_green "System updated successfully!"
  sleep 2
}

firmware_update() {
  print_in_purple "Updating firmware..."

  sudo fwupdmgr refresh --force
  sudo fwupdmgr get-devices
  sudo fwupdmgr get-updates
  sudo fwupdmgr update

  print_in_green "Firmware updated successfully!"
  sleep 2
}
