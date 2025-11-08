#!/bin/bash


# INTERFACE

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
