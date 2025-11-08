#!/bin/bash


# REPOS

flatpak_ensure_repo_is_enabled () {
  local name="$1"
  local url="$2"
  if ! flatpak_repo_is_enabled "$name"; then
    flatpak_enable_repo "$name" "$url"
  fi
}

flatpak_repo_is_enabled () {
  local name="$1"
  flatpak remote-list | grep -qi "^$name\s"
}

flatpak_enable_repo () {
  local name="$1"
  local url="$2"
  info "flatpak" "Enabling '$name' repository..."
  sudo flatpak remote-add --if-not-exists "$name" "$url"
}
