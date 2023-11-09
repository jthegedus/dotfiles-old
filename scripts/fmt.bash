#!/usr/bin/env bash

# Run shfmt on all .bash files
find . -name '*.bash' | while read -r file; do
	printf "Formatting %s\n" "$file"
	shfmt --write --language-dialect bash "$file"
done
