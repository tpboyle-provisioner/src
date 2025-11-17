#!/bin/bash


# SOURCES

source "./src/system/lowlevel/firmware.sh"


# INTERFACE

mount_default_filesystems () {
  local hdd="$1"
  local root_path="$2"
  if [[ "$ENCRYPT_ROOT" == "no" && "$ROOT_FS_TYPE" == "ext4" ]]; then
    mount_root_filesystem "${hdd}3" "$root_path"
  fi
  mount_boot_filesystem "${hdd}1" "$root_path"
}

mount_filesystem () {
  local filesystem="$1"
  local mount_path="$2"
  echo "Mounting filesystem '$filesystem' at '$mount_path'..."
  mkdir -p "$mount_path"
  mount "${filesystem}" "$mount_path"
}

unmount_filesystem () {
  local filesystem="$1"
  echo "Unmounting filesystem '$fileystem'..."
  while filesystem_is_mounted "$filesystem"; do
    umount "$filesystem"
  done
}

filesystem_is_mounted () {
  local filesystem="$1"
  local mount_path="$2"
  lsblk "$filesystem" | grep -q "$mount_path"
}


# BOOT MOUNT

mount_boot_filesystem () {
  local filesystem="$1"
  local root_path="$2"
  if [[ "$(bios_type)" == "uefi" ]]; then
    _mount_boot_filesystem_for_uefi "$filesystem" "$root_path"
  fi
}

_mount_boot_filesystem_for_uefi () {
  local filesystem="$1"
  local root_path="$2"
  mount_filesystem "$filesystem" "$root_path/boot"
}
