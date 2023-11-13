#!/usr/bin/env bash

REPO_ROOT="$(dirname "$(realpath "$0")")"

find "$REPO_ROOT/home" -type f | while read -r file; do
	target="$HOME/${file#"$REPO_ROOT"/home/}"
	mkdir -p "$(dirname "$target")"
	# "-s --symbolic", "-f --force", "-v --verbose"
	ln -s -f -v "$file" "$target"
done
