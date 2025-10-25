#!/bin/bash

source "./src/system/files.sh"

set_locale () {
  local locale="$1"
  echo "Setting the locale to '$locale'..."
  if locale_defined "$locale"; then
    if ! locale_enabled "$locale"; then
      echo "$locale" >> /etc/locale.gen
    fi
    locale-gen 1> /dev/null
    echo "LANG=$locale" > /etc/locale.conf
  else
    echo "WARNING: locale '$locale' does not exist in /etc/locale.gen!"
    echo "  The locale will not be set. This may cause issues."
  fi
}

locale_defined () {
  locale="$1"
  file_contains "/etc/locale.gen" "^#$locale"
}

locale_enabled () {
  locale="$1"
  file_contains "/etc/locale.gen" "^$locale"
}

