
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
  local root_path="$2"
  echo "Running partition jobs..."
  partition_hard_drive "$hdd"
  encrypt_and_open_partition "${hdd}3" "$CRYPT_FS_NAME"
  make_default_filesystems "$hdd"
  mount_default_filesystems "$hdd" "$root_path"
}
