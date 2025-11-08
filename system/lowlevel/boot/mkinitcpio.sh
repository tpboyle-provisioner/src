#!/bin/bash


# INTERFACE

regenerate_mkinitcpio () {
  echo "Regenerting mkinitcpio..."
  mkinitcpio -P
}
