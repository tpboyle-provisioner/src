#!/bin/bash


# INTERFACE

make_swap_filesystem () {
  partition="$1"
  echo "Making swap filesystem on partition '$partition'..."
  if swap_already_on; then
    swapoff "$partition" 1> /dev/null
  fi
  mkswap "$partition" 1> /dev/null
  swapon "$partition" 1> /dev/null
}

swap_already_on () {
  test -n "$(swapon --show)" 
}
