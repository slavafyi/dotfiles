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
      printf "%s\n" "system_base user_core dev_tools"
      ;;
    *)
      return 1
      ;;
  esac
}

print_banner() {
  print_in_blue "╭──────────────────────────────────────────────╮"
  print_in_blue "│ System setup                                 │"
  print_in_blue "╰──────────────────────────────────────────────╯"
}

print_section_title() {
  local title="$1"
  print_in_blue "› $title"
}

print_command_row() {
  local label="$1"
  local description="$2"
  printf "  %-28s %s\n" "$label" "$description"
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
    list_profiles "✗ Unknown profile: $profile"
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
  local message="${1-}"
  print_banner
  if [[ -n $message ]]; then
    print_in_red "$message"
    printf "\n"
  fi
  print_section_title "Available profiles"
  printf "\n"
  printf "  %-17s %s\n" "Name" "Description"
  printf "  %-17s %s\n" "-----------------" "----------------------------------"
  print_profile "full" "Complete workstation setup"
  print_profile "minimal-server" "Bare essentials for servers"
  print_profile "desktop" "Desktop essentials without dev tools"
  print_profile "dev-workstation" "Full desktop plus dev tooling"
}

print_profile() {
  local name="$1"
  local description="$2"
  printf "  %-17s %s\n" "$name" "$description"
  printf "  %-17s %s\n" "" "Modules: $(profile_modules $name)"
  printf "\n"
}

print_usage() {
  print_banner
  print_section_title "Usage"
  print_command_row "./install.sh [profile <name>|list-profiles|help|<function>]" ""
  printf "\n"
  print_section_title "Commands"
  print_command_row "profile <name>" "Run a named profile"
  print_command_row "list-profiles" "Show available profiles"
  print_command_row "help | -h | --help" "Show this help"
  print_command_row "<function>" "Run an individual module"
  printf "\n"
  print_section_title "Examples"
  print_command_row "./install.sh" "Full installation (default profile)"
  print_command_row "./install.sh profile desktop" "Run the desktop profile"
  print_command_row "./install.sh dev_tools" "Call an individual module"
}

if [[ $# -eq 0 ]]; then
  main
  exit 0
fi

case "$1" in
  profile)
    shift
    if [[ $# -eq 0 ]]; then
      list_profiles "✗ Missing profile name"
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
