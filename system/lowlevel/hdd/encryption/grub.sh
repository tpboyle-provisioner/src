#!/bin/bash


# INTERFACE

inform_grub_of_uuids_for_encrypted_device () {
  local encrypted_partition="$1"
  echo "Informing GRUB of encrypted block device UUIDs..."
  local encrypted_partition_uuid="$(blkid -o value -s UUID "$encrypted_partition")"
  echo "encrypted_partition_UUID: $encrypted_partition_uuid"
  local decrypted_partition_uuid="$(blkid -o value -s UUID /dev/mapper/$CRYPT_FS_NAME)"
  echo "decrypted_partition_UUID: $decrypted_partition_uuid"
  local uuid_string="cryptdevice=UUID=$encrypted_partition_uuid:cryptroot root=UUID=$decrypted_partition_uuid"
  sed -i -E "s/^(GRUB_CMDLINE_LINUX_DEFAULT=.*?)\"$/\1 $uuid_string\"/g" /etc/default/grub
}
