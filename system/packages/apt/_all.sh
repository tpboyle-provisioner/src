#!/bin/bash

# Get current directory
APT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$PACKAGES_DIR/keyrings.sh"
source "$PACKAGES_DIR/packages.sh"
source "$PACKAGES_DIR/repositories.sh"
source "$PACKAGES_DIR/sources.sh"
