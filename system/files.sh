#!/bin/bash


# INTERFACE

file_exists () {
  local filepath="$1"
  test -f "$filepath"
}

dir_exists () {
  local dirpath="$1"
  test -d "$dirpath"
}

file_contains () {
  local filepath="$1"
  local contents="$2"
  cat "$filepath" | grep -q "$contents"
}

file_contains_regex () {
  local filepath="$1"
  local contents="$2"
  cat "$filepath" | grep -Eq "$contents"
}
