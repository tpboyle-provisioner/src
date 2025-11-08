#!/bin/bash

# Get current directory
SRC_SYS_HDD_MOUNT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_HDD_MOUNT_DIR/auto.sh"
source "$SRC_SYS_HDD_MOUNT_DIR/manual.sh"
