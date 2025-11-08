#!/bin/bash

# Get current directory
SRC_SYS_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$SRC_SYS_CONFIG_DIR/clock.sh"
source "$SRC_SYS_CONFIG_DIR/hostname.sh"
source "$SRC_SYS_CONFIG_DIR/keymaps.sh"
source "$SRC_SYS_CONFIG_DIR/locales.sh"
source "$SRC_SYS_CONFIG_DIR/timezones.sh"
