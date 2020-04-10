#!/usr/bin/env bash

set -eo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

# configure bash shell options
shopt -s globstar # '**' can be used to recursively search directories
shopt -s nullglob # do nothing if no files matched
shopt -s dotglob  # match hidden files

# get absolute path of dotfiles directory
config_root="$(dirname "$(dirname "$0")")/dotfiles"
if [[ -n "$MACOS" ]]; then
    config_root="$(greadlink -f "$config_root")" # requires coreutils
else
    config_root="$(readlink -f "$config_root")"
fi

# loop through every file in dotfiles/ and create symlinks in home directory
for file in "$config_root"/**/*; do
    file_absolute_path="$file"
    file_relative_path="${file_absolute_path#$config_root/}"
    home_path="$HOME/$file_relative_path"
    if [[ ! -d $file ]]; then
        log_info "ℹ️  Symlinking ~/$file_relative_path"
        if [[ -L $home_path ]]; then
            rm -f "$home_path" # remove existing symlink
        elif [[ -f $home_path ]]; then
            backup_file="$home_path.$(date +'%Y%m%d').bak"
            mv "$home_path" "$backup_file" # backup existing file
            rm -f "$home_path"             # remove existing file
        else
            mkdir -p "$HOME/$(dirname "$file_relative_path")" # ensure directory hierarchy exists
        fi
        ln -sv "$file_absolute_path" "$home_path"
    fi
done
