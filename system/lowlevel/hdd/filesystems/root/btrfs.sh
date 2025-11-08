#!/bin/bash


# SOURCES

source "./src/system/lowlevel/hdd/mount/manual.sh"


# INTERFACE

make_btrfs_root_filesystem () {
  local partition="$1"
  make_btrfs_filesystem "$partition"
  mount_root_filesystem "$partition"
  create_btrfs_subvolumes
  unmount_root_filesystem
  mount_btrfs_subvolumes "$partition"
}


# IMPLEMENTATION

make_btrfs_filesystem () {
  local partition="$1"
  echo "Making btrfs filesystem on partition '$partition'..."
  mkfs.btrfs -f "$partition"
}

mount_root_filesystem () {
  local filesystem="$1"
  mount_filesystem "$filesystem"  "$ROOT_DIR_MOUNT"
}

unmount_root_filesystem () {
  umount "$ROOT_DIR_MOUNT"
}

create_btrfs_subvolumes () {
  create_btrfs_subvolume ""
  create_btrfs_subvolume "home"
  create_btrfs_subvolume "var"
  create_btrfs_subvolume "snapshots"
}

create_btrfs_subvolume () {
  local subvolume="$1"
  echo "Creating btrfs subvolume ${subvolume}..."
  btrfs subvolume create "/mnt/root/@${subvolume}" 1> /dev/null
}

mount_btrfs_subvolumes () {
  local partition="$1"
  mount_btrfs_subvolume "$partition" "" ""
  mount_btrfs_subvolume "$partition" "home" "home"
  mount_btrfs_subvolume "$partition" "var" "var"
  mount_btrfs_subvolume "$partition" "snapshots" ".snapshots"
}

mount_btrfs_subvolume () {
  local partition="$1"
  local subvolume="$2"
  local root_directory="$3"
  echo "Mounting btrfs subvolume '$subvolume' from partition '$partition' at /mnt/root/$root_directory..."
  mkdir -p "/mnt/root/$root_directory"
  mount -o "noatime,compress=lzo,space_cache=v2,subvol=@${subvolume}" "$partition" "/mnt/root/$root_directory"
}
