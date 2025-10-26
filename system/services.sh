#!/bin/bash

# ENABLED AND ACTIVE

ensure_service_is_enabled_and_active () {
  local name="$1"
  ensure_service_is_enabled "$name"
  ensure_service_is_active "$name"
}


# ENABLED

ensure_service_is_enabled () {
  local name="$1"
  if ! service_is_enabled "$name"; then
    enable_service "$name"
  fi
}

service_is_enabled () {
  local name="$1"
  sudo systemctl is-enabled "$name" | grep -qi "^enabled$"
}

enable_service () {
  local name="$1"
  echo "Enabling service '$name'..."
  sudo systemctl enable "${name}.service" 1> /dev/null
}


# ACTIVE

ensure_service_is_active () {
  local name="$1"
  if ! service_is_active "$name"; then
    start_service "$name"
  fi
}

service_is_active () {
  local name="$1"
  sudo systemctl is-active "$name" | grep -qi "^active$"
}

start_service () {
  local name="$1"
  echo "Starting service '$name'..."
  sudo systemctl start "$name.service" 
}
