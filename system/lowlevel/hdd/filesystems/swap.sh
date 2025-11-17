#!/bin/bash


# INTERFACE

make_swap_filesystem () {
  local partition="$1"
  echo "Making swap filesystem on partition '$partition'..."
  if swap_already_on; then
    disable_swap_filesystem "$partition"
  fi
  _make_swap_filesystem "$partition"
  enable_swap_filesystem "$partition"
}

swap_already_on () {
  test -n "$(swapon --show)" 
}

enable_swap_filesystem () {
  local partition="$1"
  swapon "$partition" 1> /dev/null
}

disable_swap_filesystem () {
  local partition="$1"
  swapoff "$partition" 1> /dev/null
}

disable_all_swap_filesystems () {
  swapoff -a &> /dev/null
}


# IMPLEMENTATION

_make_swap_filesystem () {
  local partition="$1"
  mkswap "$partition" 1> /dev/null
}