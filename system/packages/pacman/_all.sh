#!/bin/bash

# Get current directory
PACMAN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$PACMAN_DIR/config.sh"
source "$PACMAN_DIR/packages.sh"
source "$PACMAN_DIR/repos.sh"
