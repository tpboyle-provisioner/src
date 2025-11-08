#!/bin/bash

# Get current directory
APT_REPOSITORIES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# SOURCES

source "$APT_REPOSITORIES_DIR/canonical.sh"
source "$APT_REPOSITORIES_DIR/ppa.sh"
