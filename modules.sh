#!/bin/bash


# DEFINED MODULES

defined_module_lines () {
  echo "$(set | grep "^MODULE_")"
}

defined_modules () {
  echo "$(defined_module_lines | sed -E 's/^MODULE_(.*?)=.*?/\1/g')"
}

module_is_defined () {
  name="$1"
  defined_modules | grep -qi "^$name$"
}

get_module_line () {
  name="$1"
  echo "$(defined_module_lines | grep -i "MODULE_$name=")"
}


# UPDATE MODULES

update_all_modules () {
  module_lines="$(defined_module_lines)"
  while IFS= read -r module_line; do
    update_module_from_line "$module_line"
  done <<< "$module_lines"
}

update_modules () {
  for module in "$@"; do
    if [[ "$module" == "all" ]]; then
      update_all_modules
    else
      update_module "$module"
    fi
  done
}

update_module () {
  name="$1"
  if ! module_is_defined "$name"; then
    echo "Module $name is not defined!"
    return 1
  fi
  line="$(get_module_line "$name")"
  update_module_from_line "$line"
}

update_module_from_line () {
  line="$1"
  git_path="$(module_url "$line")"
  name="$(module_name "$line")"
  echo "Updating module $name ($git_path)..."
  if module_exists "$name"; then
    pull_module "$name"
  else
    clone_module "$name" "$git_path"
  fi
}


# MODULE MEMBERS

module_url () {
  line="$1"
  echo "$(echo "$line" | sed 's/^MODULE_\S*\=//g')"
}

module_name () {
  line="$1"
  url="$(module_url "$line")"
  echo "$(echo "$url" | sed -E 's/^.*?\/(.*?).git$/\1/g')"
}

module_exists () {
  name="$1"
  test -d "./modules/$name"
}


# MODULE UPDATE HELPERS

clone_module () {
  name="$1"
  git_path="$2"
  git clone "$git_path" "./modules/$name"
}

pull_module () {
  name="$1"
  cd "./modules/$name"
  git pull
  cd - &> /dev/null
}
