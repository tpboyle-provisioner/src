#!/bin/bash

# USERS

ensure_user_exists () {
  local user="$1"
  if ! user_exists "$user"; then
    create_user "$user"
  fi
}

user_exists () {
  local user="$1"
  cat /etc/passwd | grep -qE "^$user"
}

create_user () {
  local user="$1"
  shift
  local args="$@"
  useradd \
    -m \
    -s /bin/bash \
    $args \
    "$user"
}

set_user_password () {
  local user="$1"
  local password="$2"
  echo "$password" | passwd --stdin "$user"
}

configure_standard_user () {
  username="$(read_username)"
  create_user "$username"
  password="$(read_password "$username")"
  set_user_password "$username" "$password"
}

configure_root () {
  password="$(read_password "root")"
  set_user_password "root" "$password"
}

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
