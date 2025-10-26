
WHEEL_LINE="%wheel ALL=(ALL:ALL) ALL"

source "./src/system/files.sh"
source "./src/logger.sh"

sudoers_enable_wheel () {
  if wheel_group_disabled; then
    info "users" "Enabling wheel group..."
    push_sudo_editor
    sudo visudo 
    pop_sudo_editor
  else
    info "users" "Wheel group already enabled. Skipping..."
  fi
}

wheel_group_disabled () {
  file_contains "/etc/sudoers" "# $WHEEL_LINE"
}

push_sudo_editor () {
  command="$1"
  export SUDO_EDITOR_OLD="$SUDO_EDITOR"
  export SUDO_EDITOR="sed -i -e 's/# $WHEEL_LINE/$WHEEL_LINE/g'" #"$command"
}

pop_sudo_editor () {
  export SUDO_EDITOR="$SUDO_EDITOR_OLD"
}
