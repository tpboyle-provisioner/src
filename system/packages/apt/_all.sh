#!/bin/bash

# Get current directory
APT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$APT_DIR/keyrings.sh"
source "$APT_DIR/packages.sh"
source "$APT_DIR/repositories/_all.sh"
source "$APT_DIR/sources.sh"
