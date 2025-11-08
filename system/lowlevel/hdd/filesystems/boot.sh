#!/bin/bash


# INTERFACE

make_boot_filesystem () {
  local partition="$1"
  echo "Making boot filesystem on partition '$partition'..."
  mkfs.fat -F32 "${partition}" 1> /dev/null
}
