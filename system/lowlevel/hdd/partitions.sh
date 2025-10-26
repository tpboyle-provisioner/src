#!/bin/bash

source "./src/system/files.sh"
source "./src/system/lowlevel/firmware.sh"

BOOT_PARTITION_NUMBER=1
SWAP_PARTITION_NUMBER=2
ROOT_PARTITION_NUMBER=3

BOOT_PARTITION_SIZE="+512M"
SWAP_PARTITION_SIZE="+8G"
ROOT_PARTITION_SIZE="0"

SWAP_PARTITION_TYPE="8200"
ROOT_PARTITION_TYPE="8300"


# PARTITIONS

wipe_hard_drive () {
  local hdd="$1"
  dd if=/dev/zero of="$hdd" status=progress
}

partition_hard_drive () {
  local hdd="$1"
  echo "Partitioning hard drive '$hdd'..."
  create_gpt_table "$hdd"
  create_partitions "$hdd"
}

create_gpt_table () {
  local hdd="$1"
  delete_gpt_table "$hdd"
  echo "Creating a new GPT table..."
  sgdisk -g "$hdd" #1> /dev/null
}

delete_gpt_table () {
  local hdd="$1"
  prep_for_deleting_gpt_table "$hdd"
  echo "Deleting any existing GPT table from '$hdd'..."
  sgdisk --zap-all "$hdd" #1> /dev/null
}

prep_for_deleting_gpt_table () {
  local hdd="$1"
  echo "Preparing to delete any existing GPT table from '$hdd'..."
  swapoff ${hdd}* &> /dev/null
  umount ${hdd}* &> /dev/null
}

create_partitions () {
  local hdd="$1"
  create_boot_partition "$hdd"
  create_swap_partition "$hdd"
  create_root_partition "$hdd"
}

create_boot_partition () {
  local hdd="$1"
  echo "Creating boot partition..."
  local boot_partition_type="$(get_boot_partition_type)"
  create_partition \
    "$hdd" \
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
  local hdd="$1"
  echo "Creating swap partition..."
  create_partition \
    "$hdd" \
    "$SWAP_PARTITION_NUMBER" \
    "$SWAP_PARTITION_SIZE" \
    "$SWAP_PARTITION_TYPE" \
    "swap"
}

create_root_partition () {
  local hdd="$1"
  echo "Creating root partition..."
  create_partition \
    "$hdd" \
    "$ROOT_PARTITION_NUMBER" \
    "$ROOT_PARTITION_SIZE" \
    "$ROOT_PARTITION_TYPE" \
    "root"
}

create_partition () {
  local hdd="$1"
  local number="$2"
  local size="$3"
  local type="$4"
  local name="$5"
  sgdisk \
    -n "$number::$size" \
    -t "$number:$type" \
    -c "$number:$name" \
    "$hdd" \
      1> /dev/null
}

