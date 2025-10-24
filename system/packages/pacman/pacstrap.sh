#!/bin/bash

pacman_run_pacstrap () {
  local root_path="$1"
  pacman_prep_partition_for_pacstrap
  echo "Running pacstrap..."
  pacstrap "$root_path" \
    base \
    base-devel \
    linux \
    linux-firmware \
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

pacman_prep_partition_for_pacstrap () {
  echo "Clearing root partition..."
  rm -rf /mnt/root/{*,.*}
}
