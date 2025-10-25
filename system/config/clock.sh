#!/bin/bash

synchronize_os_clock () {
  echo "Synchronizing the OS clock with NTP..."
  timedatectl set-ntp true
}

synchronize_hardware_clock () {
  echo "Synchronizing the hardware clock with the OS clock..."
  hwclock --systohc
}
