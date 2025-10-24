#!/bin/bash

source "./src/system/files.sh"

set_keymap () {
  local keymap="$1"
  if ! keymap_is_defined "$keymap"; then
    return 1
  fi
  loadkeys "$keymap"
  echo "KEYMAP=$keymap" > /etc/vconsole.conf
}

keymap_is_defined () {
  local keymap="$1"
  localectl list-keymaps | grep -q "$keymap"
}
