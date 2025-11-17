#!/bin/bash


# SOURCES

source "./src/system/files.sh"
source "./src/system/lowlevel/firmware.sh"


# CONSTANTS

SWAP_PARTITION_TYPE="8200"
ROOT_PARTITION_TYPE="8300"


# CONFIG

BOOT_PARTITION_NUMBER=1
SWAP_PARTITION_NUMBER=2
ROOT_PARTITION_NUMBER=3

DEFAULT_BOOT_PARTITION_SIZE="+512M"
DEFAULT_SWAP_PARTITION_SIZE="+8G"
DEFAULT_ROOT_PARTITION_SIZE="0"


# PARTITIONS

create_default_partitions () {
  local hdd="$1"
  create_boot_partition "$hdd"
  create_swap_partition "$hdd"
  create_root_partition "$hdd"
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


# BOOT PARTITION

create_boot_partition () {
  local hdd="$1"
  echo "Creating boot partition..."
  local boot_partition_type="$(_get_boot_partition_type)"
  local partition_size="${BOOT_PARTITION_SIZE:-DEFAULT_BOOT_PARTITION_SIZE}"
  create_partition \
    "$hdd" \
    "$BOOT_PARTITION_NUMBER" \
    "$partition_size" \
    "$boot_partition_type" \
    "boot"
}

_get_boot_partition_type () {
  local type="ef02"  # default to bios
  if [[ "$(bios_type)" == "uefi" ]]; then
    type="ef00"
  fi
  echo "$type"
}


# SWAP PARTITION

create_swap_partition () {
  local hdd="$1"
  echo "Creating swap partition..."
  local partition_size="${SWAP_PARTITION_SIZE:-DEFAULT_SWAP_PARTITION_SIZE}"
  create_partition \
    "$hdd" \
    "$SWAP_PARTITION_NUMBER" \
    "$partition_size" \
    "$SWAP_PARTITION_TYPE" \
    "swap"
}


# ROOT PARTITION

create_root_partition () {
  local hdd="$1"
  echo "Creating root partition..."
  local partition_size="${ROOT_PARTITION_SIZE:-DEFAULT_ROOT_PARTITION_SIZE}"
  create_partition \
    "$hdd" \
    "$ROOT_PARTITION_NUMBER" \
    "$partition_size" \
    "$ROOT_PARTITION_TYPE" \
    "root"
}

