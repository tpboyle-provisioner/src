#!/bin/bash


# INTERFACE

set_hostname () {
  local name="$1"
  echo "Setting hostname to '$name'..."
  echo "$name" > /etc/hostname
}
