#!/bin/bash


# SOURCES

source "./src/system/lowlevel/boot/mkinitcpio.sh"


# INTERFACE

enable_encryption_in_mkinitcpio () {
  echo "Enabling encryption in mkinitcpio..."
  update_mkinitcpio
  regenerate_mkinitcpio
}

update_mkinitcpio () {
  echo "Updating /etc/mkinitcpio.conf to enable encryption..."
  sed -i -E "s/^(HOOKS=.*?)block filesystems/\1block encrypt lvm2 filesystems/" /etc/mkinitcpio.conf
}
