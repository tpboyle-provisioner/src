
FLATHUB_REPO_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"


# PACKAGES

flatpak_ensure_packages_are_installed () {
  local repo="$1"
  shift
  local packages=("$@")
  for package in "${packages[@]}"; do
    flatpak_ensure_package_is_installed "$repo" "$package"
  done
}

flatpak_ensure_package_is_installed () {
  local repo="$1"
  local package="$2"
  _ensure_flatpak_is_setup
  if ! flatpak_repo_is_enabled "$repo"; then
    warn "flatpak" \
      "Repository '$repo' is not enabled - necessary for package '$package' to be installed!"
  elif ! flatpak_package_is_installed "$package"; then
    flatpak_install "$repo" "$package"
  fi
}

flatpak_package_is_installed () {
  local package="$1"
  flatpak list | grep -qi "\s$package\s"
}

flatpak_install () {
  local repo="$1"
  local package="$2"
  info "flatpak" "Installing package '$package' from repo '$repo'..."
  sudo flatpak install -y "$repo" "$package"
}


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
