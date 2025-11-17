#!/bin/bash


# SOURCES

source "./src/system/files.sh"


# INTERFACE

set_locale () {
  local locale="$1"
  echo "Setting the locale to '$locale'..."
  if locale_defined "$locale"; then
    _set_locale "$locale"
  else
    echo "WARNING: locale '$locale' does not exist in /etc/locale.gen!"
    echo "  The locale will not be set. This may cause issues."
  fi
}

locale_defined () {
  local locale="$1"
  file_contains_regex "/etc/locale.gen" "^#?$locale"
}


# IMPLEMENTATION

_set_locale () {
  local locale="$1"
  if ! _locale_generation_enabled_for "$locale"; then
    _exclusively_enable_locale_generation_for "$locale"
  fi
  _generate_locale
  _set_locale_conf "$locale"
}

_locale_generation_enabled_for () {
  local locale="$1"
  file_contains_regex "/etc/locale.gen" "^$locale"
}

_exclusively_enable_locale_generation_for () {
  local locale="$1"
  _disable_all_locale_generation
  _enable_locale_generation_for "$locale"
}

_enable_locale_generation_for () {
  local locale="$1"
  sed -i -E "s/^#$locale/$locale/g" /etc/locale.gen
}

_disable_all_locale_generation () {
  sed -i '/^ *#/!s/^/#/' /etc/locale.gen
}

_generate_locale () {
  locale-gen # 1> /dev/null
}

_set_locale_conf () {
  local locale="$1"
  echo "LANG=$LOCALE_SHORT" > /etc/locale.conf
}
