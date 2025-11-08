#!/bin/bash


# INTERFACE

pacman_run_pacstrap () {
  local root_path="$1"
  # _pacman_prep_partition_for_pacstrap "$root_path"
  echo "Running pacstrap on root path '$root_path'..."
  pacstrap "$root_path" \
    base \
    base-devel \
    linux \
    linux-firmware \
    man \
    man-pages \
    nano \
    vim \
    networkmanager \
    lvm2 \
    cryptsetup \
    grub \
    grub-btrfs \
    efibootmgr \
    snapper
}


# IMPLEMENTATION

_pacman_prep_partition_for_pacstrap () {
  local root_path="$1"
  echo "Clearing root partition..."
  rm -rf "$root_path/{*,.*}"
}
