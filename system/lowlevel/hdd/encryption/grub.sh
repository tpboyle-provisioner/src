#!/bin/bash


# SOURCES

source "./src/system/lowlevel/hdd/partitions/actions/info.sh"


# INTERFACE

inform_grub_of_uuids_for_encrypted_device () {
  local encrypted_partition="$1"
  local crypt_fs_name="$2"
  echo "Informing GRUB of encrypted block device UUIDs..."
  local encrypted_partition_uuid="$(partition_get_uuid "$encrypted_partition")"
  local uuid_string="$(_generate_grub_uuid_string "$encrypted_partition_uuid" "$crypt_fs_name")"
  _update_grub_cmdline_linux_default "$uuid_string"
}


# IMPLEMENTATION

_generate_grub_uuid_string () {
  local encrypted_partition_uuid="$1"
  local crypt_fs_name="$2"
  echo "$(_generate_grub_uuid_string_for_systemd_mkinitcpio "$encrypted_partition_uuid" "$crypt_fs_name")"
  # TODO: Implement switcher for systemd/udev string...
}

_generate_grub_uuid_string_for_systemd_mkinitcpio () {
  local encrypted_partition_uuid="$1"
  local crypt_fs_name="$2"
  echo "rd.luks.name=$encrypted_partition_uuid=$crypt_fs_name root=/dev/mapper/$crypt_fs_name"
}

_generate_grub_uuid_string_for_udev_mkinitcpio () {
  local encrypted_partition_uuid="$1"
  local crypt_fs_name="$2"
  echo "cryptdevice=$encrypted_partition_uuid:$crypt_fs_name root=/dev/mapper/$crypt_fs_name"
}

_update_grub_cmdline_linux_default () {
  local uuid_string="$1"
  sed -i -E "s@^(GRUB_CMDLINE_LINUX_DEFAULT=.*?quiet).*?\"@\1 $uuid_string\"@g" /etc/default/grub
}
