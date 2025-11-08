#!/bin/bash


# INTERFACE

encrypt_and_open_partition () {
  local partition="$1"
  local filesystem_name="$2"
  prepare_for_encrypting_partition
  encrypt_partition "$partition"
  if [[ "$?" == "1" ]]; then
    echo_encryption_error_and_exit
  fi
  open_encrypted_partition "$partition" "$filesystem_name"
}

encrypt_partition () {
  local partition="$1"
  echo "Encrypting partition '$partition'..."
  cryptsetup -v luksFormat "$partition"
}

open_encrypted_partition () {
  local partition="$1"
  local filesystem_name="$2"
  echo "Opening encrypted partition '$partition' as '$filesystem_name'..."
  cryptsetup open "$partition" "$filesystem_name"
}

unmount_all_encrypted_partitions () {
  for device in /dev/mapper/*; do
    mapping_name=$(basename "$device")
    if cryptsetup status "$mapping_name" &> /dev/null; then
      sudo cryptsetup luksClose "$mapping_name"
    fi
  done
}


# IMPLEMENTATION

prepare_for_encrypting_partition () {
  if [[ -e "/dev/mapper/$filesystem_name" ]]; then
    cryptsetup luksClose "$filesystem_name"
  fi
}

echo_encryption_error_and_exit () {
  echo "ERROR: Did not successfully complete encryption setup!"
  echo "Exiting..."
  exit 1
}
