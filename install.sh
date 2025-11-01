#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname -- "$(readlink -f -- "$0")")"

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
  system_base
  user_core
  desktop_env
  dev_tools
  optional_extras
}

if [ "${1-}" == "" ]; then
  main
else
  "$@"
fi
