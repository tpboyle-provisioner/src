#!/bin/bash


# SOURCES

source "./src/system/lowlevel/boot/mkinitcpio.sh"


# INTERFACE

enable_encryption_in_mkinitcpio () {
  echo "Enabling encryption in /etc/mkinitcpio.conf..."
  _enable_encryption_in_mkinitcpio
  regenerate_mkinitcpio
}


# IMPLEMANTION

_enable_encryption_in_mkinitcpio () {
  # if _is_systemd_mkinitcpio; then
    _enable_encryption_in_systemd_mkinitcpio
  # else
  #   _enable_encryption_in_udev_mkinitcpio
  # fi 
}

_enable_encryption_in_systemd_mkinitcpio () {
  sed -i -E "s/^(HOOKS=.*?)kms block/\1kms keyboard sd-vconsole block/" /etc/mkinitcpio.conf
  sed -i -E "s/^(HOOKS=.*?)block filesystems/\1block sd-encrypt filesystems/" /etc/mkinitcpio.conf
}

_enable_encryption_in_udev_mkinitcpio () {
  sed -i -E "s/^(HOOKS=.*?)kms block/\1kms keyboard keymap consolefont block/" /etc/mkinitcpio.conf
  sed -i -E "s/^(HOOKS=.*?)block filesystems/\1block encrypt lvm2 filesystems/" /etc/mkinitcpio.conf
}
