#!/bin/bash


# CONSTANTS

SKEL_PATH="/etc/skel"


# INTERFACE

ensure_skel_is_set_up () {
  set_up_skel
}


# IMPLEMENTATION

set_up_skel () {
  mkdir -p "$SKEL_PATH/Desktop"
  mkdir -p "$SKEL_PATH/Downloads"
  mkdir -p "$SKEL_PATH/Documents"
  mkdir -p "$SKEL_PATH/Pictures"
  mkdir -p "$SKEL_PATH/Videos"
}
