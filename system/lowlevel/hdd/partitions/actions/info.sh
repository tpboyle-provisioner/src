#!/bin/bash


# INTERFACE

partition_get_uuid () {
  local partition="$1"
  echo "$(blkid -o value -s UUID "$partition")"
}
