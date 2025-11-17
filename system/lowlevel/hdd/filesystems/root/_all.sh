#!/bin/bash

# Get current directory
SRC_SYS_FILESYSTEMS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "./src/system/lowlevel/hdd/mount/manual.sh"

source "$SRC_SYS_FILESYSTEMS_ROOT_DIR/btrfs.sh"
source "$SRC_SYS_FILESYSTEMS_ROOT_DIR/ext4.sh"


# INTERFACE

make_root_filesystem () {
  local partition="$1"
  local type="$2"
  local root_dir_mount="$3"
  case "$type" in
    "ext4")
      make_ext4_root_filesystem "$partition" "$root_dir_mount" ;;
    "btrfs"|*)
      make_btrfs_root_filesystem "$partition" "$root_dir_mount" ;;
  esac
}

mount_root_filesystem () {
  local filesystem="$1"
  local root_dir_mount="$2"
  case "$type" in
    "ext4")
      mount_filesystem "$filesystem" "$root_dir_mount" ;;
    "btrfs"|*)
      mount_btrfs_root_filesystem "$partition" ;;
  esac
}

unmount_root_filesystem () {
  local root_dir_mount="$1"
  umount "$root_dir_mount"
}
