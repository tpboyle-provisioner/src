#!/bin/bash

# Get current directory
SRC_SYS_FILESYSTEMS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_FILESYSTEMS_DIR/boot.sh"
source "$SRC_SYS_FILESYSTEMS_DIR/root/_all.sh"
source "$SRC_SYS_FILESYSTEMS_DIR/swap.sh"


# INTERFACE

make_default_filesystems () {
  local hdd="$1"
  local root_partition="$2"
  local root_fs_type="$3"
  local root_dir_mount="$4"
  make_boot_filesystem "${hdd}1"
  make_swap_filesystem "${hdd}2"
  make_root_filesystem "${root_partition:-${hdd}3}" "$root_fs_type" "$root_dir_mount"
}
