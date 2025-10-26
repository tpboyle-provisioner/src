#!/bin/bash

source "./src/system/lowlevel/firmware.sh"


# MOUNT

mount_partitions () {
  local hdd="$1"
  local root_path="$2"
  mount_root_partition "${hdd}3" "$root_path"
  mount_boot_partition "${hdd}1" "$root_path"
}

mount_boot_partition () {
  local partition="$1"
  local root_path="$2"
  echo "Mounting boot partition '$partition' at '$root_path/boot/efi'..."
  if [[ "$(bios_type)" == "uefi" ]]; then
    mkdir -p "$root_path/boot/efi"
    mount "${partition}" "$root_path/boot/efi"
  fi
}

mount_root_partition () {
  local partition="$1"
  local root_path="$2"
  echo "Mounting root partition '$partition' at '$root_path'..."
  mkdir -p "$root_path"
  mount "${partition}" "$root_path"
}


# AUTOMOUNT

automount_root_on_startup () {
  local root_path="$1"
  generate_fstab "$root_path"
}

generate_fstab () {
  local root_path="$1"
  echo "Generating fstab with root = '$root_path'..."
  genfstab -U "$root_path" > "$root_path/etc/fstab"
}
