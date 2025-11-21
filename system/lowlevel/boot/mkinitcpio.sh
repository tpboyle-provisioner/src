#!/bin/bash


# INTERFACE

regenerate_mkinitcpio () {
  echo "Regenerating mkinitcpio..."
  mkinitcpio -P
}
