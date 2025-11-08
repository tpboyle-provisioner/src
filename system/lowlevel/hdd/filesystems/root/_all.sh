#!/bin/bash

# Get current directory
SRC_SYS_FILESYSTEMS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_FILESYSTEMS_ROOT_DIR/btrfs.sh"
source "$SRC_SYS_FILESYSTEMS_ROOT_DIR/ext4.sh"


# INTERFACE

make_root_filesystem () {
  partition="$1"
  type="$2"
  case "$type" in
    "ext4")
      make_ext4_root_filesystem "$partition" ;;
    "btrfs"|*)
      make_btrfs_root_filesystem "$partition" ;;
  esac
}
