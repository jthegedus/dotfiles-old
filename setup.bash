#!/usr/bin/env bash

REPO_ROOT="$(dirname "$(realpath "$0")")"

find "$REPO_ROOT/home" -type f | while read file
do
  target="$HOME/${file#$REPO_ROOT/home/}"
  ln --symbolic --force --verbose "$file" "$target"
done
