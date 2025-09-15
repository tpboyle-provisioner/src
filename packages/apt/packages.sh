#!/bin/bash

# Get current directory
APT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$APT_DIR/../dpkg.sh"


# PACKAGES

apt_update () {
  sudo apt update
}

apt_install () {
  local package="$1"
  info "apt" "Installing package '$package'..."
  sudo apt install -y "$package" &> /dev/null
}

apt_package_is_installed () {
  local package="$1"
  dpkg_package_is_installed "$package"
}

apt_ensure_packages_are_installed () {
  local packages=("$@")
  for package in "${packages[@]}"; do
    apt_ensure_package_is_installed "$package"
  done
}

apt_ensure_package_is_installed () {
  local package="$1"
  if ! apt_package_is_installed "$package"; then
    apt_install "$package"
  fi
}
