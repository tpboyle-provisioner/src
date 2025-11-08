#!/bin/bash


# CONFIG

DEB_LOCATION="/tmp/install.deb"


# INTERFACE

dpkg_ensure_package_is_installed () {
  local package="$1"
  local url="$2"
  if ! dpkg_package_is_installed "$package"; then
    dpkg_install_deb_from_url "$url"
  fi
}

dpkg_package_is_installed () {
  local package="$1"
  dpkg -l | grep -q "^ii\s\+$package[ :]"
}

dpkg_install_deb_from_url () {
  local url="$1"
  wget -O "$DEB_LOCATION" "$url"
  sudo dpkg -i "$DEB_LOCATION"
}
