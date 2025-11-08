#!/bin/bash


# CONFIG

APT_SOURCES_LIST_PATH="/etc/apt/sources.list.d"


# INTERFACE

apt_ensure_sources_file_exists () {
  name="$1"
  url="$2"
  if ! apt_sources_file_exists "$name"; then
    apt_manually_write_sources_file "$name" "$url"
  fi
}

apt_sources_file_exists () {
  name="$1"
  sources_fn="$name.list"
  ls "$APT_SOURCES_LIST_PATH" | grep -qi "$sources_fn"
}

apt_manually_write_sources_file () {
  name="$1"
  url="$2"
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=$APT_KEYRINGS_PATH/$name.asc] $url \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
    | sudo tee "$APT_SOURCES_LIST_PATH/$name.list" > /dev/null
  sudo apt update
}
