#!/bin/bash

# Get current directory
SRC_SYS_PARTITIONS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_PARTITIONS_DIR/actions/_all.sh"
source "$SRC_SYS_PARTITIONS_DIR/partition_table.sh"


# ALL

partition_hard_drive () {
  local hdd="$1"
  echo "Partitioning hard drive '$hdd'..."
  create_partition_table "$hdd"
  create_default_partitions "$hdd"
}
