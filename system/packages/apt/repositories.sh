#!/bin/bash

# Get current directory
APT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# CANONICAL REPOSITORIES

apt_ensure_canonical_repository_is_enabled () {
  local name="$1"
  if ! apt_canonical_repository_is_enabled "$name"; then
    apt_enable_canonical_repository "$name"
  fi
}

apt_canonical_repository_is_enabled () {
  local repo="$1"
  cat /etc/apt/sources.list.d/ubuntu.sources | grep ^Component | grep -q "$repo"
}

apt_enable_canonical_repository () {
  local name="$1"
  info "apt" "Enabling Canonical repository '$name'..."
  sudo add-apt-repository -y "$name"
  sudo apt update
}


# PPA REPOSITORIES

apt_ensure_ppa_repository_is_installed () {
  local name="$1"
  local source_file="$2"
  if ! apt_ppa_repository_is_installed "$source_file"; then
    apt_install_ppa_repository "$name"
  fi
}

apt_ppa_repository_is_installed () {
  local source_file="$1"
  ls /etc/apt/sources.list.d | grep -qiE "$source_file"
}

apt_install_ppa_repository () {
  local name="$1"
  info "apt" "Installing PPA repository '$name'..."
  sudo add-apt-repository -y "$name"
  sudo apt update
}
