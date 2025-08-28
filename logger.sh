
debug () {
  module="$1"
  message="$2"
  log "debug" "$module" "$message"
}

info () {
  module="$1"
  message="$2"
  log "info" "$module" "$message"
}

warn () {
  module="$1"
  message="$2"
  log "warn" "$module" "$message"
}

error () {
  module="$1"
  message="$2"
  log "error" "$module" "$message"
}

log () {
  level="$1"
  module="$2"
  message="$3"
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$timestamp :: $level :: $module :: $message"
}
