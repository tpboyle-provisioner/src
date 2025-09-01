#!/bin/bash

# Get current directory
PACKAGES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$PACKAGES_DIR/dpkg.sh"

apt_update () {
  sudo apt update
}

apt_install () {
  package="$1"
  info "apt" "Installing package '$package'..."
  sudo apt install -y "$package" &> /dev/null
}

apt_package_is_installed () {
  package="$1"
  dpkg_package_is_installed "$package"
}

apt_ensure_packages_are_installed () {
  packages=("$@")
  for package in "${packages[@]}"; do
    apt_ensure_package_is_installed "$package"
  done
}

apt_ensure_package_is_installed () {
  package="$1"
  if ! apt_package_is_installed "$package"; then
    apt_install "$package"
  fi
}


# REPOSITORIES

apt_default_repository_is_enabled () {
  name="$1"
  cat /etc/apt/sources.list.d/ubuntu.sources | grep $name
}

apt_ensure_default_repository_is_enabled () {
  name="$1"
  if ! apt_default_repository_is_enabled "$name"; then
    apt_enable_default_repository "$name"
  fi
}

apt_enable_default_repository () {
  sudo add-apt-repository "$name"
  sudo apt update
}

# - name: Check if KeePassXC PPA is present
#   shell: grep -h ^ /etc/apt/sources.list /etc/apt/sources.list.d/*.list | grep ''
#   register: keepassxc_ppa_check
#   ignore_errors: yes

# - name: "keepass : Add KeePassXC PPA"
#   apt_repository:
#     repo: ppa:phoerious/keepassxc
#     state: present
#   when: keepassxc_ppa_check.rc != 0

# - be sure to 'apt update (cache?)' after this point!!

