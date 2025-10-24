#!/bin/bash

set_locale () {
  local locale="$1"
  # TODO: check that this works!
  if [[ file_contains "/etc/locale.gen" "^$locale$" ]]; then
    echo "$locale" >> /etc/locale.gen
    locale-gen
    echo "LANG=$locale" > /etc/locale.conf
  fi
}
