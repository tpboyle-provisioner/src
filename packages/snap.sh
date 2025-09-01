#!/bin/bash

snap_install () {
  info "snap" "Installing package '$1'..."
  sudo snap install "$@" &> /dev/null
}

snap_package_is_installed () {
  package="$1"
  if snap list | grep -q "^$package"; then
    return 0
  else
    return 1
  fi
}

snap_ensure_package_is_installed () {
  package="$1"
  if ! $(snap_package_is_installed "$package"); then
    snap_install "$@"
  fi
}

snap_ensure_packages_are_installed () {
  packages=("$@")
  for package in "${packages[@]}"; do
    snap_ensure_package_is_installed "$package"
  done
}
