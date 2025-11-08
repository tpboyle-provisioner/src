#!/bin/bash

# Get current directory
FLATPAK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$FLATPAK_DIR/packages.sh"
source "$FLATPAK_DIR/repos.sh"
