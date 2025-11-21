
#!/bin/bash

# Get current directory
SRC_HDD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_HDD_DIR/encryption/partition.sh"
source "$SRC_HDD_DIR/filesystems/_all.sh"
source "$SRC_HDD_DIR/mount/_all.sh"
source "$SRC_HDD_DIR/partitions/_all.sh"


# ALL

run_partition_jobs () {
  local hdd="$1"
  local root_dir_mount="$2"
  local root_fs_type="$3"
  local encrypt_root="$4"
  local crypt_fs_name="$5"
  local root_partition_name="$(partition_get_name "$hdd" "3")"
  echo "Running partition jobs..."
  partition_hard_drive "$hdd"
  if [[ "$encrypt_root" == "yes" ]]; then
    encrypt_and_open_partition "$root_partition_name" "$crypt_fs_name"
    make_default_filesystems "$hdd" "/dev/mapper/$crypt_fs_name" "$root_fs_type" "$root_dir_mount"
  else
    make_default_filesystems "$hdd" "$root_partition_name" "$root_fs_type" "$root_dir_mount"
  fi
  mount_default_filesystems "$hdd" "$root_dir_mount"
}
