#!/usr/bin/env bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
NC="\033[0m" # No Color

print_in_red() {
  printf "${RED}%s${NC}\n" "$1"
}

print_in_green() {
  printf "${GREEN}%s${NC}\n" "$1"
}

print_in_yellow() {
  printf "${YELLOW}%s${NC}\n" "$1"
}

print_in_blue() {
  printf "${BLUE}%s${NC}\n" "$1"
}

print_in_purple() {
  printf "${PURPLE}%s${NC}\n" "$1"
}

ask_for_sudo() {
  sudo -v &> /dev/null

  # Update existing `sudo` time stamp until this script has finished.
  # https://gist.github.com/cowboy/3118588
  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2> /dev/null &

  print_in_yellow "Sudo password cached"
}

detect_os() {
  local os=""

  if [[ $OSTYPE == "darwin"* ]]; then
    os="macos"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
      debian|ubuntu)
        os="debian"
        ;;
      fedora)
        os="fedora"
        ;;
      arch)
        os="arch"
        ;;
      *)
        os="unknown"
        ;;
    esac
  else
    os="unknown"
  fi

  echo "$os"
}
