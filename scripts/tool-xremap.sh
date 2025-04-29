#!/usr/bin/env bash

source ./scripts/utils.sh

print_in_purple "Configuring Xremap..."

sudo usermod -aG input $USER
mkdir -p ~/.config/systemd/user

cat << EOF > ~/.config/systemd/user/xremap.service
[Unit]
Description=Xremap daemon
After=network.target

[Service]
ExecStart=/usr/bin/xremap --watch=device,config %h/.config/xremap/config.yml
ExecStop=/usr/bin/killall xremap
Restart=always

[Install]
WantedBy=default.target
EOF

echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules
sudo modprobe uinput

echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf
sudo systemctl restart systemd-modules-load.service

systemctl --user daemon-reload
systemctl --user enable xremap.service
systemctl --user start xremap.service

print_in_green "Xremap configured successfully!"
