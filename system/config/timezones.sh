#!/bin/bash

TIMEZONES_DIR="/usr/share/zoneinfo"

set_timezone () {
  local zone="$1"
  if timezone_exists "$zone"; then
    link_timezone "$zone"
  else
    echo "WARNING: Timezone $zone does not exist in $TIMEZONES_DIR!"
    echo "...not setting a timezone..."
  fi

}

timezone_exists () {
  local zone="$1"
  file_exists "$TIMEZONES_DIR/$zone"
}

link_timezone () {
  ln -sf "$TIMEZONES_DIR/$zone" /etc/localtime
}
