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
  defined_modules | grep -qi "$name"
}

get_module_line () {
  name="$1"
  echo "$(defined_module_lines | grep -i "MODULE_$name=")"
}


# DOWNLOAD MODULES

download_all_modules () {
  module_lines="$(defined_module_lines)"
  while IFS= read -r module_line; do
    download_module_from_line "$module_line"
  done <<< "$module_lines"
}

download_modules () {
  for module in "$@"; do
    if [[ "$module" == "all" ]]; then
      download_all_modules
    elif module_is_defined "$module"; then
      download_module "$module"
    fi
  done
}

download_module () {
  name="$1"
  line="$(get_module_line "$name")"
  download_module_from_line "$line"
}

download_module_from_line () {
  line="$1"
  git_path="$(module_url "$line")"
  name="$(module_name "$line")"
  echo "Downloading module $name ($git_path)..."
  if module_exists "$name"; then
    update_module "$name"
  else
    clone_module "$name" "$git_path"
  fi
  ln -sf "$ROOT_DIR/src" "./modules/$name/src"
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


# MODULE DOWNLOAD HELPERS

clone_module () {
  name="$1"
  git_path="$2"
  git clone "$git_path" "./modules/$name"
}

update_module () {
  name="$1"
  cd "./modules/$name"
  git pull
  cd -
}
