#!/bin/bash


# FILESYSTEMS

make_filesystems () {
  make_boot_filesystem
  make_swap_filesystem
  make_root_filesystem
}

make_boot_filesystem () {
  echo "Making boot filesystem..."
  mkfs.fat -F32 "${DEVICE}1" 1> /dev/null
}

make_swap_filesystem () {
  echo "Making swap filesystem..."
  if swap_already_on; then
    swapoff "${DEVICE}2" 1> /dev/null
  fi
  mkswap "${DEVICE}2" 1> /dev/null
  swapon "${DEVICE}2" 1> /dev/null
}

swap_already_on () {
  test -n "$(swapon --show)" 
}

make_root_filesystem () {
  echo "Making root filesystem..."
  unmount_root_filesystem
  mkfs.ext4 "${DEVICE}3" 1> /dev/null
}

unmount_root_filesystem () {
  while root_filesystem_is_mounted; do
    umount "${DEVICE}3"  # can alternately unmount the folder /mnt/root
  done
}

root_filesystem_is_mounted () {
  lsblk "${DEVICE}3" | grep -q /mnt/root
}
