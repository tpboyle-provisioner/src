#!/bin/bash


# INTERFACE

unmount_all_partitions_for_hdd () {
  local hdd="$1"
  umount ${hdd}* &> /dev/null
}
