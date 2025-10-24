#!/bin/bash

# MOUNT

mount_partitions () {
  mount_boot_partition
  mount_root_partition
}

mount_boot_partition () {
  if [[ "$(bios_type)" == "uefi" ]]; then
    mkdir -p /mnt/boot/efi
    mount "${DEVICE}1" /mnt/boot/efi
  fi
}

mount_root_partition () {
  mkdir -p /mnt/root
  mount "${DEVICE}3" /mnt/root
}


# AUTOMOUNT

automount_root_on_startup () {
  local root_path="$1"
  generate_fstab "$root_path"
}

generate_fstab () {
  local root_path="$1"
  genfstab -U "$root_path" > "$root_path/etc/fstab"
}
