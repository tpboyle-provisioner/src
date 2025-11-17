#!/bin/bash

# Get current directory
SRC_SYS_PARTITIONS_ACTIONS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_PARTITIONS_ACTIONS_DIR/create.sh"
source "$SRC_SYS_PARTITIONS_ACTIONS_DIR/info.sh"
source "$SRC_SYS_PARTITIONS_ACTIONS_DIR/other.sh"
