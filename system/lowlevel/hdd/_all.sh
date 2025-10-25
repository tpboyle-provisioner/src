#!/bin/bash

source "./src/system/lowlevel/hdd/filesystems.sh"
source "./src/system/lowlevel/hdd/mount.sh"
source "./src/system/lowlevel/hdd/partitions.sh"


# ALL

run_partition_jobs () {
  local hdd="$1"
  local root_path="$2"
  echo
  echo "=== PARTITIONING '$hdd' ==="
  echo
  partition_hard_drive "$hdd"
  make_filesystems "$hdd"
  mount_partitions "$hdd" "$root_path"
}
