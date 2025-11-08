#!/bin/bash


# INTERFACE

header () {
  title="$1"
  echo
  echo "=== $title ==="
  echo
}

debug () {
  local module="$1"
  local message="$2"
  log "debug" "$module" "$message"
}

info () {
  local module="$1"
  local message="$2"
  log "info" "$module" "$message"
}

warn () {
  local module="$1"
  local message="$2"
  log "warn" "$module" "$message"
}

error () {
  local module="$1"
  local message="$2"
  log "error" "$module" "$message"
}

log () {
  local level="$1"
  local module="$2"
  local message="$3"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$timestamp :: $level :: $module :: $message"
}
