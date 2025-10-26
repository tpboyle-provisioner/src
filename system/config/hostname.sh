#!/bin/bash

set_hostname () {
  local name="$1"
  echo "$name" > /etc/hostname
}
