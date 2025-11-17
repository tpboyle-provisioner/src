#!/bin/bash


# INTERFACE

pacman_ensure_packages_are_installed () {
  IFS=' ' read -r -a packages <<< "$@"
  for package in "${packages[@]}"; do
    pacman_ensure_package_is_installed "$package"
  done
}

pacman_ensure_package_is_installed () {
  local package="$@"
  if ! pacman_package_is_installed "$package"; then
    pacman_install_package "$package"
  fi
}

pacman_package_is_installed () {
  local package="$1"
  pacman --query 2> /dev/null | grep "$package"
}

pacman_install_package () {
  local package="$1"
  info "pacman" "Installing package '$package'..."
  pacman -Sy "$package"
}
