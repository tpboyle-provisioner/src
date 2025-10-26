#!/bin/bash


# FILESYSTEMS

make_filesystems () {
  local hdd="$1"
  make_boot_filesystem "${hdd}1"
  make_swap_filesystem "${hdd}2"
  make_root_filesystem "${hdd}3"
}

make_boot_filesystem () {
  local partition="$1"
  echo "Making boot filesystem on partition '$partition'..."
  mkfs.fat -F32 "${partition}" 1> /dev/null
}

make_swap_filesystem () {
  local partition="$1"
  echo "Making swap filesystem on partition '$partition'..."
  if swap_already_on; then
    swapoff "$partition" 1> /dev/null
  fi
  mkswap "$partition" 1> /dev/null
  swapon "$partition" 1> /dev/null
}

swap_already_on () {
  test -n "$(swapon --show)" 
}

make_root_filesystem () {
  local partition="$1"
  echo "Making root filesystem on partition '$partition'..."
  unmount_root_filesystem "$partition"
  mkfs.ext4 "$partition" 1> /dev/null
}

unmount_root_filesystem () {
  local partition="$1"
  while root_filesystem_is_mounted "$partition"; do
    umount "$partition"  # can alternately unmount the folder /mnt/root
  done
}

root_filesystem_is_mounted () {
  local partition="$1"
  lsblk "$partition" | grep -q /mnt/root
}
