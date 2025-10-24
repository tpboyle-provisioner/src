#!/bin/bash

source "./src/system/files.sh"

DEVICE="/dev/vda"

BOOT_PARTITION_NUMBER=1
SWAP_PARTITION_NUMBER=2
ROOT_PARTITION_NUMBER=3

BOOT_PARTITION_SIZE="+512M"
SWAP_PARTITION_SIZE="+8G"
ROOT_PARTITION_SIZE="0"

SWAP_PARTITION_TYPE="8200"
ROOT_PARTITION_TYPE="8300"


# ALL

run_partition_jobs () {
  partition_hard_drive
  make_filesystems
  mount_partitions
}

# PARTITIONS

wipe_hard_drive () {
  dd if=/dev/zero of="$DEVICE" status=progress
}

partition_hard_drive () {
  echo "Partitioning hard drive..."
  create_gpt_table
  create_boot_partition
  create_swap_partition
  create_root_partition
}

delete_gpt_table () {
  echo "Deleting any existing GPT table..."
  sgdisk --zap-all $DEVICE 1> /dev/null
}

create_gpt_table () {
  delete_gpt_table
  echo "Creating a new GPT table..."
  sgdisk -g $DEVICE 1> /dev/null
}

create_boot_partition () {
  echo "Creating boot partition..."
  local boot_partition_type="$(get_boot_partition_type)"
  create_partition \
    "$BOOT_PARTITION_NUMBER" \
    "$BOOT_PARTITION_SIZE" \
    "$boot_partition_type" \
    "boot"
}

get_boot_partition_type () {
  local type="ef02"  # default to bios
  if [[ "$(bios_type)" == "uefi" ]]; then
    type="ef00"
  fi
  echo "$type"
}

create_swap_partition () {
  echo "Creating swap partition..."
  create_partition \
    "$SWAP_PARTITION_NUMBER" \
    "$SWAP_PARTITION_SIZE" \
    "$SWAP_PARTITION_TYPE" \
    "swap"
}

create_root_partition () {
  echo "Creating root partition..."
  create_partition \
    "$ROOT_PARTITION_NUMBER" \
    "$ROOT_PARTITION_SIZE" \
    "$ROOT_PARTITION_TYPE" \
    "root"
}

create_partition () {
  local number="$1"
  local size="$2"
  local type="$3"
  local name="$4"
  sgdisk \
    -n "$number::$size" \
    -t "$number:$type" \
    -c "$number:$name" \
    "$DEVICE" \
      1> /dev/null
}

