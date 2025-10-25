#!/bin/bash

source "./src/system/lowlevel/firmware.sh"

install_bootloader () {
  local type="$(bios_type)"
  # if [[ "$type" != "bios" && "$type" != uefi ]]; then
  #   exit 0;
  # fi
  if [[ "$type" == "bios" ]]; then
    install_bootloader_for_bios
  elif [[  "$type" == "uefi" ]]; then
    install_bootloader_for_uefi
  fi
  grub-mkconfig -o /boot/grub/grub.cfg
}

install_bootloader_for_bios () {
  grub-install "$DEVICE"
}

install_bootloader_for_uefi () {
  grub-install \
    --target=x86_64-efi \
    --bootloader-id=GRUB \
    --efi-directory=/boot/efi
}
