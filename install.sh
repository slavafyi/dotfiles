#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname -- "$(readlink -f -- "$0")")"
DEFAULT_PROFILE="full"

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

source "$DIR/scripts/common/main.sh"

print_in_blue "Current dotfiles directory: $DIR"

OS="$(detect_os)"

if [[ $OS != "unknown" ]]; then
  print_in_blue "Detected operating system: $OS"
  source "$DIR/scripts/$OS/main.sh"
else
  print_in_red "✗ Operating system not recognized, aborting"
  exit 1
fi

ask_for_sudo

main() {
  run_profile "$DEFAULT_PROFILE"
}

profile_modules() {
  local profile="$1"

  case "$profile" in
    full)
      printf "%s\n" "system_base user_core desktop_env dev_tools optional_extras"
      ;;
    minimal-server)
      printf "%s\n" "system_base user_core"
      ;;
    desktop)
      printf "%s\n" "system_base user_core desktop_env optional_extras"
      ;;
    dev-workstation)
      printf "%s\n" "system_base user_core desktop_env dev_tools optional_extras"
      ;;
    *)
      print_in_red "✗ Unknown profile: $profile"
      exit 1
      ;;
  esac
}

run_profile() {
  local profile="$1"
  local modules

  modules="$(profile_modules "$profile")"

  print_in_blue "→ Running profile: $profile"

  for module in $modules; do
    print_in_blue "→ Executing $module"
    "$module"
  done
}

list_profiles() {
  printf "Available profiles:\n"
  print_profile "full" "Complete workstation setup"
  print_profile "minimal-server" "Bare essentials for servers"
  print_profile "desktop" "Desktop essentials without dev tools"
  print_profile "dev-workstation" "Full desktop plus dev tooling"
}

print_profile() {
  local name="$1"
  local description="$2"

  printf "  %-17s %s\n" "$name" "$description"
  printf "      %s\n" "$(profile_modules "$name")"
}

print_usage() {
  cat << 'EOF'
Usage: ./install.sh [profile <name>|list-profiles|help|<function>]

Examples:
  ./install.sh                  # full installation (default profile)
  ./install.sh profile desktop  # run named profile
  ./install.sh list-profiles    # show available profiles
  ./install.sh dev_tools        # call individual module
EOF
}

if [[ $# -eq 0 ]]; then
  main
  exit 0
fi

case "$1" in
  profile)
    shift
    if [[ $# -eq 0 ]]; then
      print_in_red "✗ Missing profile name"
      list_profiles
      exit 1
    fi
    run_profile "$1"
    ;;
  list-profiles)
    list_profiles
    ;;
  help | -h | --help)
    print_usage
    ;;
  *)
    "$@"
    ;;
esac
