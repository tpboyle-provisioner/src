#!/bin/bash


# SOURCES

source "./src/system/lowlevel/hdd/encryption/partition.sh"


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
  umount "$BOOT_DIR_MOUNT"
  umount "$ROOT_DIR_MOUNT"
  unmount_all_encrypted_partitions
  swapoff -a &> /dev/null
  umount ${hdd}* &> /dev/null
}
