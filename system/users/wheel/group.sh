#!/bin/bash


# SOURCES

source "./src/logger.sh"
source "./src/system/files.sh"


# CONSTANTS

WHEEL_LINE="%wheel ALL=(ALL:ALL) ALL"


# INTERFACE

enable_wheel_group () {
  if wheel_group_disabled; then
    info "users" "Enabling wheel group..."
    _enable_wheel_group
  else
    info "users" "Wheel group already enabled. Skipping..."
  fi
}

wheel_group_disabled () {
  file_contains "/etc/sudoers" "# $WHEEL_LINE"
}


# IMPLEMENTATION

_enable_wheel_group () {
  _push_sudo_editor
  sudo visudo 
  _pop_sudo_editor
}

_push_sudo_editor () {
  local command="$1"
  export SUDO_EDITOR_OLD="$SUDO_EDITOR"
  export SUDO_EDITOR="sed -i -e 's/# $WHEEL_LINE/$WHEEL_LINE/g'" #"$command"
}

_pop_sudo_editor () {
  export SUDO_EDITOR="$SUDO_EDITOR_OLD"
}
