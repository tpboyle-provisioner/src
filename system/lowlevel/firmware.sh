#!/bin/bash

source "./src/system/files.sh"

bios_type () {
  local output="bios"
  if dir_exists /sys/firmware/efi/efivars; then
    output="uefi"
  fi
  echo "$output"
}
