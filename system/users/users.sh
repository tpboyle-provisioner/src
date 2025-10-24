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
    "$args" \
    "$user"
}
