
apt_install () {
  package="$1"
  info "apt" "Installing package '$package'..."
  sudo apt install -y "$package" &> /dev/null
}

apt_package_is_installed () {
  package="$1"
  dpkg -l | grep -q "^ii\s\+$package "
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
