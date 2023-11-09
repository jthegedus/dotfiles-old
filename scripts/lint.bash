#!/usr/bin/env bash

# Run Shellcheck & Shfmt on all .bash files
find . -name '*.bash' | while read -r file; do
	printf "Linting %s\n" "$file"
	shellcheck --shell=bash "$file"
	shfmt --diff --language-dialect bash "$file"
done
