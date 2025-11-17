#!/bin/bash


# SOURCES

source "./src/system/lowlevel/hdd/mount/manual.sh"


# INTERFACE

make_btrfs_root_filesystem () {
  local partition="$1"
  local root_dir_mount="$2"
  make_btrfs_filesystem "$partition"
  create_default_btrfs_subvolumes "$partition" "$root_dir_mount"
  mount_btrfs_root_filesystem "$partition" "$root_dir_mount"
}

mount_btrfs_root_filesystem () {
  local partition="$1"
  local root_dir_mount="$2"
  mount_btrfs_subvolumes "$partition" "$root_dir_mount"
}


# IMPLEMENTATION

make_btrfs_filesystem () {
  local partition="$1"
  echo "Making btrfs filesystem on partition '$partition'..."
  mkfs.btrfs -f "$partition"
}

create_default_btrfs_subvolumes () {
  local partition="$1"
  local root_dir_mount="$2"
  prepare_for_creating_btrfs_subvolumes "$partition" "$root_dir_mount"
  echo "Creating btrfs subvolumes at '$root_dir_mount'..."
  create_btrfs_subvolume "" "$root_dir_mount"
  create_btrfs_subvolume "home" "$root_dir_mount"
  create_btrfs_subvolume "var" "$root_dir_mount"
  create_btrfs_subvolume "snapshots" "$root_dir_mount"
  cleanup_after_creating_btrfs_subvolumes "$root_dir_mount"
}

prepare_for_creating_btrfs_subvolumes () {
  local partition="$1"
  local root_dir_mount="$2"
  echo "Preparing to create btrfs subvolumes at `$root_dir_mount`..."
  umount "$root_dir_mount"
  rm -rf "$root_dir_mount"
  mkdir -p "$root_dir_mount"
  mount "$partition" "$root_dir_mount"
}

cleanup_after_creating_btrfs_subvolumes () {
  local root_dir_mount="$2"
  echo "Cleaning up after creating btrfs subvolumes at '$root_dir_mount'..."
  umount "$root_dir_mount"
}

create_btrfs_subvolume () {
  local subvolume="$1"
  local root_dir_mount="$2"
  echo "Creating btrfs subvolume ${subvolume}..."
  btrfs subvolume create "$root_dir_mount/@${subvolume}" 1> /dev/null
}

mount_btrfs_subvolumes () {
  local partition="$1"
  local root_dir_mount="$2"
  mount_btrfs_subvolume "$partition" "" "$root_dir_mount" ""
  mount_btrfs_subvolume "$partition" "home" "$root_dir_mount" "home"
  mount_btrfs_subvolume "$partition" "var" "$root_dir_mount" "var"
  mount_btrfs_subvolume "$partition" "snapshots" "$root_dir_mount" ".snapshots"
}

mount_btrfs_subvolume () {
  local partition="$1"
  local subvolume="$2"
  local root_dir_mount="$3"
  local root_directory="$4"
  local dir_path="$root_dir_mount/$root_directory"
  echo "Mounting btrfs subvolume '$subvolume' from partition '$partition' at $dir_path..."
  mkdir -p "$dir_path"
  local args="noatime,compress=lzo,space_cache=v2,subvol=@${subvolume}"
  mount -o "$args" "$partition" "$dir_path"
}
