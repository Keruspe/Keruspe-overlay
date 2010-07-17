#!/bin/bash

REPOSITORIES_PATH="/var/paludis/repositories"
VDB_PATH="/var/db/pkg"

find_duplicates() {
  local first_path=${REPOSITORIES_PATH}/${1}
  local second_path=${REPOSITORIES_PATH}/${2}
  pushd ${first_path} &>/dev/null
  echo "Duplicate packages between ${1} and ${2}:"
  echo
  for i in $(find . -name '*.ebuild'); do 
    ls ${second_path}/${i} &>/dev/null && echo ${i} | cut -d/ -f2,4 | sed 's/\.ebuild//g';
  done
  echo
  popd &>/dev/null
}

find_unused() {
  local repo_path=${REPOSITORIES_PATH}/${1}
  pushd ${repo_path} &>/dev/null
  echo "Unused packages in ${1}:"
  echo
  for i in $(find . -name '*.ebuild' | cut -d/ -f2,4 | sed 's/\.ebuild//g'); do 
    ls ${VDB_PATH}/${i} &>/dev/null || echo ${i}
  done
  echo
  popd &>/dev/null
}

main() {
  find_duplicates keruspe gnome
  find_unused keruspe
}

main
