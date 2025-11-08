#!/bin/bash


# SOURCE

source "./src/system/users/groups.sh"


# INTERFACE

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
