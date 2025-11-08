#!/bin/bash


# INTERFACE

make_ext4_root_filesystem () {
  local partition="$1"
  echo "Making root filesystem on partition '$partition'..."
  unmount_root_filesystem "$partition"
  mkfs.ext4 "$partition" 1> /dev/null
}
