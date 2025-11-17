#!/bin/bash


# CONSTANTS

SKEL_PATH="/etc/skel"


# INTERFACE

ensure_skel_is_set_up () {
  _set_up_skel
}


# IMPLEMENTATION

_set_up_skel () {
  # TODO: use an array to clean this phrasing up (i.e. remove dependence on `mkdir -p` already being idempotic)
  mkdir -p "$SKEL_PATH/Desktop"
  mkdir -p "$SKEL_PATH/Downloads"
  mkdir -p "$SKEL_PATH/Documents"
  mkdir -p "$SKEL_PATH/Pictures"
  mkdir -p "$SKEL_PATH/Videos"
}
