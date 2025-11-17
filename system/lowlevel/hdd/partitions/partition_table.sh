#!/bin/bash


# SOURCES

source "./src/system/lowlevel/hdd/encryption/partition.sh"
source "./src/system/lowlevel/hdd/filesystems/swap.sh"
source "./src/system/lowlevel/hdd/partitions/actions/_all.sh"


# INTERFACE

create_partition_table () {
  local hdd="$1"
  delete_partition_table "$hdd"
  echo "Creating a new partition table (GPT)..."
  sgdisk -g "$hdd" #1> /dev/null
}

delete_partition_table () {
  local hdd="$1"
  _prep_for_deleting_partition_table "$hdd"
  echo "Deleting any existing partition table from '$hdd'..."
  sgdisk --zap-all "$hdd" #1> /dev/null
}


# IMPLEMENTATION

_prep_for_deleting_partition_table () {
  local hdd="$1"
  echo "Preparing to delete any existing partition table from '$hdd'..."
  umount "$BOOT_DIR_MOUNT" &> /dev/null
  umount "$ROOT_DIR_MOUNT" &> /dev/null
  unmount_all_encrypted_partitions
  disable_all_swap_filesystems
  unmount_all_partitions_for_hdd "$hdd"
}
