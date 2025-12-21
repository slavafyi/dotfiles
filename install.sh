#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname -- "$(readlink -f -- "$0")")"

source "$DIR/scripts/common/main.sh"

DEFAULT_PROFILE="full"
OS="$(detect_os)"

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
      return 1
      ;;
  esac
}

prepare_install() {
  if [[ $OS != "unknown" ]]; then
    source "$DIR/scripts/$OS/main.sh"
  else
    print_in_red "✗ Operating system not recognized, aborting"
    exit 1
  fi

  print_in_blue "Current dotfiles directory: $DIR"
  print_in_blue "Detected operating system: $OS"

  ask_for_sudo
}

run_profile() {
  local profile="$1"
  local modules

  if ! modules="$(profile_modules $profile)"; then
    print_in_red "✗ Unknown profile: $profile"
    list_profiles
    exit 1
  fi

  prepare_install

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
    prepare_install
    "$@"
    ;;
esac
