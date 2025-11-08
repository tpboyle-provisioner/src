#!/bin/bash


# SOURCES

source "./src/system/lowlevel/firmware.sh"
source "./src/system/lowlevel/hdd/encryption/_all.sh"


# INTERFACE

install_bootloader () {
  _install_bootloader_for_current_bios_type
  _make_grub_config
}

install_bootloader_for_encrypted_root () {
  enable_encryption_in_mkinitcpio
  _install_bootloader_for_current_bios_type
  inform_grub_of_uuids_for_encrypted_device /dev/vda3
  _make_grub_config
}


# IMPLEMENTATION

_install_bootloader_for_current_bios_type () {
  local type="$(bios_type)"
  if [[ "$type" == "bios" ]]; then
    _install_bootloader_for_bios
  elif [[  "$type" == "uefi" ]]; then
    _install_bootloader_for_uefi
  fi
}

_install_bootloader_for_bios () {
  grub-install "$DEVICE"
}

_install_bootloader_for_uefi () {
  grub-install \
    --target=x86_64-efi \
    --bootloader-id=ArchLinux \
    --efi-directory=/boot
}

_make_grub_config () {
  grub-mkconfig -o /boot/grub/grub.cfg
}

