#!/bin/bash


# INTERFACE

partition_get_uuid () {
  local partition="$1"
  echo "$(blkid -o value -s UUID "$partition")"
}

partition_get_name () {
  local hdd="$1"
  local partition_number="$2"
  local partition_prefix="$(_get_partition_prefix "$hdd" "$partition_number")"
  local partition_name="$hdd$partition_prefix$partition_number"
  echo "$partition_name"
}


# IMPLEMENTATION

_get_partition_prefix () {
  local hdd="$1"
  local partition_number="$2"
  local prefix=""
  if [[ "$hdd" =~ "nvme" ]]; then
    prefix="p"
  fi
  echo "$prefix"
}