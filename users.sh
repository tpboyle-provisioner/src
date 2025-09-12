

# GROUPS

ensure_user_is_in_groups () {
  local user="$1"
  shift
  groups=("$@")
  for group in "${groups[@]}"; do
    ensure_user_is_in_group "$user" "$group"
  done
}

ensure_user_is_in_group () {
  local user="$1"
  local group="$2"
  if ! user_is_in_group "$user" "$group"; then
    sudo usermod -aG "$group" "$user"
  fi
}

user_is_in_group () {
  local user="$1"
  local group="$2"
  id -nG "$user" | grep -qw "$group"
}
