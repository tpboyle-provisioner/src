#!/bin/bash

# Get current directory
APT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# REPOSITORIES

apt_ppa_repository_is_installed () {
  local source_file="$1"
  ls /etc/apt/sources.list.d | grep -qi "$source_file"
}

apt_ensure_ppa_repository_is_installed () {
  local name="$1"
  local source_file="$2"
  if ! apt_ppa_repository_is_installed "$source_file"; then
    apt_install_ppa_repository "$name"
  fi
}

apt_install_ppa_repository () {
  info "apt" "Installing PPA repository '$name'..."
  sudo add-apt-repository -y "$name"
  sudo apt update
}
