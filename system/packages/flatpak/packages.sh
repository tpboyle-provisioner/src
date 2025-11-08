#!/bin/bash

# Get current directory
FLATPAK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$FLATPAK_DIR/_setup.sh"


# INTERFACE

flatpak_ensure_packages_are_installed () {
  local repo="$1"
  shift
  local packages=("$@")
  for package in "${packages[@]}"; do
    flatpak_ensure_package_is_installed "$repo" "$package"
  done
}

flatpak_ensure_package_is_installed () {
  local repo="$1"
  local package="$2"
  _ensure_flatpak_is_setup
  if ! flatpak_repo_is_enabled "$repo"; then
    warn "flatpak" \
      "Repository '$repo' is not enabled - necessary for package '$package' to be installed!"
  elif ! flatpak_package_is_installed "$package"; then
    flatpak_install_package "$repo" "$package"
  fi
}

flatpak_package_is_installed () {
  local package="$1"
  flatpak list | grep -qi "\s$package\s"
}

flatpak_install_package () {
  local repo="$1"
  local package="$2"
  info "flatpak" "Installing package '$package' from repo '$repo'..."
  sudo flatpak install -y "$repo" "$package"
}
