#!/usr/bin/env bash

set -euo pipefail

DIR="$(dirname -- "$(readlink -f -- "$0")")"

source "$DIR/scripts/common/main.sh"

print_in_blue "Current dotfiles directory: $DIR"

os="$(detect_os)"

if [[ $os != "unknown" ]]; then
  print_in_green "Detected Operating System: $os"
  source "$DIR/scripts/$os/main.sh"
else
  print_in_yellow "Operating System not recognized. No setup script will be sourced."
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
