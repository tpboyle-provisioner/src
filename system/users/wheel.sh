#!/bin/bash

# WHEEL

ensure_wheel_user_exists () {
  local user="$1"
  if ! wheel_user_exists "$user"; then
    create_wheel_user "$user"
  fi
}

wheel_user_exists () {
  local user="$1"
  user_exists "$user"
    && groups "$user" | grep "wheel"
}

create_wheel_user () {
  local user="$1"
  create_user "$user"
  ensure_user_is_in_group "$user" "$wheel"
}
