#!/bin/bash


# INTERFACE

automount_filesystems_on_startup () {
  local root_path="$1"
  generate_fstab "$root_path"
}

generate_fstab () {
  local root_path="$1"
  echo "Generating fstab with root = '$root_path'..."
  genfstab -U "$root_path" > "$root_path/etc/fstab"
}
