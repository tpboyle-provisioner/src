#!/bin/bash


# IMPLEMENTATION

snap_ensure_packages_are_installed () {
  local packages=("$@")
  for package in "${packages[@]}"; do
    snap_ensure_package_is_installed "$package"
  done
}

snap_ensure_package_is_installed () {
  local package="$1"
  if ! $(snap_package_is_installed "$package"); then
    snap_install_package "$@"
  fi
}

snap_package_is_installed () {
  local package="$1"
  if snap list | grep -q "^$package"; then
    return 0
  else
    return 1
  fi
}

snap_install_package () {
  info "snap" "Installing package '$1'..."
  sudo snap install "$@" &> /dev/null
}
