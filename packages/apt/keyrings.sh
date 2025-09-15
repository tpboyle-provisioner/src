#!/bin/bash

# Get current directory
APT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# CONFIG

APT_KEYRINGS_PATH="/etc/apt/keyrings"


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
