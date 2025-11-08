#!/bin/bash

# Get current directory
SRC_USERS_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "./src/system/users/groups.sh"
source "$SRC_USERS_CONFIG_DIR/auto.sh"


# INTERFACE

configure_root () {
  password="$(read_password "root")"
  set_user_password "root" "$password"
}

configure_sudoer_user () {
  username="$(configure_standard_user)"
  ensure_user_is_in_group "$username" "wheel"
}

configure_standard_user () {
  username="$(read_username)"
  create_user "$username"
  password="$(read_password "$username")"
  set_user_password "$username" "$password"
  echo "$username"
}


# IMPLEMENTATION

read_username () {
  read -p "Enter the standard user's name [$DEFAULT_USER_NAME]: " name
  name=${name:-$DEFAULT_USER_NAME}
  echo "$name"
  return 0
}

read_password () {
  user="$1"
  default_user_password="${user^}1234!"
  while true; do
    read -s -p "Enter $user's password [$default_user_password]: " pass
    echo >&2
    pass=${pass:-$default_user_password}
    if [[ "$pass" == "$default_user_password" ]]; then
      break
    else
      read -s -p "Enter $user's password again: " pass2
      echo >&2
      if [[ "$pass" == "$pass2" ]]; then
        break
      else
        echo "Passwords do not match!" >&2
      fi
    fi
  done
  echo "$pass"
  return 0
}
