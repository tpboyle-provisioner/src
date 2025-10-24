#!/bin/bash

PACMAN_CONF="/etc/pacman.conf"
PACMAN_PARALLEL_DOWNLOADS=4

# CONFIGURATION

pacman_enable_parallel_downloads () {
  if ! file_contains "$PACMAN_CONF" "^ParallelDownloads = \S+$"; then
    echo "ParallelDownloads = $PACMAN_PARALLEL_DOWNLOADS" >> "$PACMAN_CONF"
  fi
}
