#!/bin/bash


# CONFIG

FLATHUB_REPO_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"


# SETUP

_ensure_flatpak_is_setup () {
  _ensure_flatpak_is_installed
  _ensure_flathub_repo_is_enabled
}

_ensure_flatpak_is_installed () {
  apt_ensure_package_is_installed flatpak
}

_ensure_flathub_repo_is_enabled () {
  flatpak_ensure_repo_is_enabled "flathub" "$FLATHUB_REPO_URL"
}
