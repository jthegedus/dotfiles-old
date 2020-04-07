#!/usr/bin/env bash

### OS variables
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1
grep -q -i "microsoft" /proc/version 2>/dev/null && export WSL=1

### Logging functions
function log_failure_and_exit() {
    printf "🚨  %s\\n" "${@}"
    exit 1
}

function log_failure() {
    printf "🚨  %s\\n" "${@}"
}

function log_info() {
    printf "ℹ️   %s\\n" "${@}"
}

function log_success() {
    printf "✅  %s\\n" "${@}"
}

function log_warning() {
    printf "⚠️  %s\\n" "${@}"
}
# END Logging

function asdf_plugin_setup() {
    log_info "Installing ${1} via asdf"
    asdf plugin add "${1}" || true
    # TODO: fix so a more precise check of output is performed
    #
    # status_code=$(asdf plugin add "${1}")
    # if [ "$status_code" -eq 0 ] || [ "$status_code" -eq 2 ]; then
    #     log_success "asdf plugin ${1} is installed"
    # else
    #     log_failure_and_exit "asdf plugin add ${1} encountered an error during operation. Run this command manually to debug the issue."
    # fi
    asdf install "${1}" latest
    asdf global "${1}" "$(asdf list "${1}" | xargs echo)"
    log_success "Successfully installed ${1} via asdf"
}

### Utility functions
# checks if command is available
function is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# backup file if exists
function backup_file() {
    local file="$1"
    if [[ -L $file ]]; then
        rm -fv "$file" # file is symlink, safely remove
    elif [[ -f $file ]]; then
        backup_file="$file.$(date +'%Y%m%d').bak"
        mv -fv --backup=t "$file" "$backup_file" # backup existing file
        rm -fv "$file"; # remove existing file
    fi
}
