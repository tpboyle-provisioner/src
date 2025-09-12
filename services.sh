
ensure_service_is_active () {
  local name="$1"
  sudo systemctl is-active "$name" | grep -qi "^active$"
}
