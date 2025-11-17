#!/bin/bash


# CONFIG

APT_KEYRINGS_PATH="/etc/apt/keyrings"


# INTERFACE

apt_ensure_key_is_installed () {
  local name="$1"
  local url="$2"
  if ! apt_key_is_installed "$name"; then
    apt_install_key "$name" "$url"
  fi
}

apt_key_is_installed () {
  local name="$1"
  local key_fn="$name.asc"
  ls "$APT_KEYRINGS_PATH" | grep -qi "$key_fn"
}

apt_install_key () {
  local name="$1"
  local key_url="$2"
  local key_fn="$APT_KEYRINGS_PATH/$name.asc"
  sudo curl -fsSL "$key_url" -o "$key_fn"
  sudo chmod a+r "$key_fn"
}


# IMPLEMENTATION

_apt_ensure_keyrings_dir_exists () {
  if [ -d "$APT_KEYRINGS_PATH" ]; then
    sudo install -m 0755 -d "$APT_KEYRINGS_PATH"
  fi
}
