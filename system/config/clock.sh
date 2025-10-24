#!/bin/bash

synchronize_os_clock () {
  timedatectl set-ntp true
}

synchronize_hardware_clock () {
  hwclock --systohc
}
