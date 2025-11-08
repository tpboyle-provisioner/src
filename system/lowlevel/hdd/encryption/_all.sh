#!/bin/bash

# Get current directory
SRC_SYS_HDD_ENCRYPTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_HDD_ENCRYPTION_DIR/grub.sh"
source "$SRC_SYS_HDD_ENCRYPTION_DIR/mkinitcpio.sh"
source "$SRC_SYS_HDD_ENCRYPTION_DIR/partition.sh"
