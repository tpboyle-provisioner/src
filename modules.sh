#!/bin/bash


# ADD MODULES

add_modules () {
  for module in "$@"; do
    add_module "$module"
  done
}

add_module () {
  local name="$1"
  if ! module_is_defined "$name"; then
    echo "Module $name is not defined!"
    return 1
  fi
  local line="$(get_module_line "$name")"
  local git_path="$(module_url "$line")"
  if module_installed "$name"; then
    echo "Module $name already exists; skipping."
  else
    echo "Adding module $name ($git_path)..."
    clone_module "$name" "$git_path"
  fi
}


# REMOVE MODULES

rm_modules () {
  for module in "$@"; do
    rm_module "$module"
  done
}

rm_module () {
  local name="$1"
  if ! module_is_defined "$name"; then
    echo "Module $name is not defined!"
    return 1
  fi
  if module_installed "$name"; then
    rm -rf "./modules/$name"
    echo "Module $name removed."
  else
    echo "Module $name does not exist; skipping."
  fi
}


# UPDATE MODULES

update_modules () {
  local modules="$@"
  [[ -z "$modules" ]] && \
    modules=( $(installed_modules) )
  for module in "${modules[@]}"; do
    update_module "$module"
  done
}

update_module () {
  local name="$1"
  if ! module_is_defined "$name"; then
    echo "Module $name is not defined!"
    return 1
  fi
  local line="$(get_module_line "$name")"
  update_module_from_line "$line"
}

update_module_from_line () {
  local line="$1"
  local git_path="$(module_url "$line")"
  local name="$(module_name "$line")"
  if module_installed "$name"; then
    echo "Updating module $name ($git_path)..."
    pull_module "$name"
  else
    echo "Adding module $name ($git_path)..."
    clone_module "$name" "$git_path"
  fi
}


# RUN MODULES

run_modules () {
  local modules="$@"
  [[ -z "$modules" ]] && \
    modules=( $(installed_modules) )
  for module in "${modules[@]}"; do
    run_module "$module"
  done
}

run_module () {
  local name="$1"
  if ! module_is_defined "$name"; then
    echo "Module $name is not defined!"
    return 1
  fi
  if ! module_installed "$name"; then
    echo "Module $name is not installed!"
    return 1
  fi
  "./modules/$name/provision.sh"
}


# CONF MODULES

conf_modules () {
  modules="$@"
  for module in $modules; do
    conf_module "$module"
  done
}

conf_module () {
  module="$1"
  if [[ -d "./modules/$module" ]]; then
    edit_module_conf_if_exists "$module"
  else
    echo "ERROR: No such module to configure: $1"
    return 1
  fi
}

edit_module_conf_if_exists () {
  module="$1"
  if [[ -f "./modules/$module/conf.sh" ]]; then
    edit_module_conf "$module"
  else
    echo "ERROR: No conf.sh present for module: $module"
    return 1
  fi
}

edit_module_conf () {
  "${EDITOR:-vim}" "./modules/$1/conf.sh"
}


# MODULE DEFINITIONS

defined_module_lines () {
  echo "$(set | grep "^MODULE_")"
}

defined_modules () {
  echo "$(defined_module_lines | sed -E 's/^MODULE_(.*?)=.*?/\1/g')" 
}

module_is_defined () {
  local name="$1"
  defined_modules | grep -qi "^$name$"
}

get_module_line () {
  local name="$1"
  echo "$(defined_module_lines | grep -i "MODULE_$name=")"
}


# MODULE MEMBERS

module_url () {
  local line="$1"
  echo "$(echo "$line" | sed 's/^MODULE_\S*\=//g')"
}

module_name () {
  local line="$1"
  local url="$(module_url "$line")"
  echo "$(echo "$url" | sed -E 's/^.*?\/(.*?).git$/\1/g')"
}

module_installed () {
  local name="$1"
  test -d "./modules/$name"
}

installed_modules () {
  local dir="./modules"
  local folders=()
  for folder in ./modules/*/; do
    if [ -d "$folder" ]; then
      folders+=( "$(basename "$folder")" )
    fi
  done
  echo "${folders[@]}"
}


# MODULE UPDATE HELPERS

clone_module () {
  local name="$1"
  local git_path="$2"
  git clone "$git_path" "./modules/$name"
}

pull_module () {
  local name="$1"
  cd "./modules/$name"
  git pull
  cd - &> /dev/null
}
