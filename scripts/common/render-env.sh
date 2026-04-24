#!/usr/bin/env bash

OS="$(detect_os)"

_env_keys() {
  local file line

  for file in "$DIR/configs/env/.config/env/base.sh" "$XDG_CONFIG_HOME/env/local.sh"; do
    [ -f "$file" ] || continue

    while IFS= read -r line; do
      [[ $line =~ ^[[:space:]]*export[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)= ]] || continue
      printf "%s\n" "${BASH_REMATCH[1]}"
    done < "$file"
  done
}

_escape_squotes() {
  printf "%s" "$1" | sed "s/'/'\\\\''/g"
}

_render_fish() {
  local out="$HOME/.config/fish/conf.d/10-env-generated.fish"
  mkdir -p "$(dirname "$out")"
  : > "$out"

  while IFS= read -r key; do
    local value="${!key:-}"
    [ -n "$value" ] || continue
    printf "set -gx %s \"%s\"\n" "$key" "$(_escape_squotes "$value")" >> "$out"
  done < <(_env_keys)
}

_render_environmentd() {
  local out="$HOME/.config/environment.d/10-dotfiles.conf"
  mkdir -p "$(dirname "$out")"
  : > "$out"

  while IFS= read -r key; do
    local value="${!key:-}"
    [ -n "$value" ] || continue
    printf "%s=%s\n" "$key" "$value" >> "$out"
  done < <(_env_keys)
}

_render_launchd_script() {
  local out="$HOME/.config/env/apply-launchd-env.sh"
  mkdir -p "$(dirname "$out")"
  : > "$out"

  while IFS= read -r key; do
    local value="${!key:-}"
    [ -n "$value" ] || continue
    printf "launchctl setenv %s %s\n" "$key" "$value" >> "$out"
  done < <(_env_keys)

  chmod +x "$out"
}

_render_launchd_plist() {
  local user_name
  user_name="$(id -un)"
  local out="$HOME/Library/LaunchAgents/com.$user_name.apply-env.plist"
  local script="$HOME/.config/env/apply-launchd-env.sh"

  mkdir -p "$(dirname "$out")"

  cat > "$out" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.$user_name.apply-env</string>

    <key>ProgramArguments</key>
    <array>
      <string>$script</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF
}

render_env() {
  case "$OS" in
    arch | debian)
      _render_fish
      _render_environmentd
      ;;
    macos)
      _render_fish
      _render_launchd_script
      _render_launchd_plist
      ;;
  esac
}
