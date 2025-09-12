#!/bin/bash

# Get current directory
PACKAGES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

APT_KEYRINGS_PATH="/etc/apt/keyrings"
APT_SOURCES_LIST_PATH="/etc/apt/sources.list.d"

source "$PACKAGES_DIR/dpkg.sh"

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


# KEYRINGS

apt_ensure_key_is_installed () {
  name="$1"
  url="$2"
  if ! apt_key_is_installed "$name"; then
    apt_install_key "$name" "$url"
  fi
}

apt_key_is_installed () {
  name="$1"
  key_fn="$name.asc"
  ls "$APT_KEYRINGS_PATH" | grep -qi "$key_fn"
}

apt_install_key () {
  name="$1"
  key_url="$2"
  key_fn="$APT_KEYRINGS_PATH/$name.asc"
  sudo curl -fsSL "$key_url" -o "$key_fn"
  sudo chmod a+r "$key_fn"
}

_apt_ensure_keyrings_dir_exists () {
  if [ -d "$APT_KEYRINGS_PATH" ]; then
    sudo install -m 0755 -d "$APT_KEYRINGS_PATH"
  fi
}


# SOURCES

apt_ensure_sources_file_exists () {
  name="$1"
  url="$2"
  if ! apt_sources_file_exists "$name"; then
    apt_manually_write_sources_file "$name" "$url"
  fi
}

apt_sources_file_exists () {
  name="$1"
  sources_fn="$name.list"
  ls "$APT_SOURCES_LIST_PATH" | grep -qi "$sources_fn"
}

apt_manually_write_sources_file () {
  name="$1"
  url="$2"
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=$APT_KEYRINGS_PATH/$name.asc] $url \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
    | sudo tee "$APT_SOURCES_LIST_PATH/$name.list" > /dev/null
  sudo apt update
}
