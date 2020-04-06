#!/usr/bin/env bash

set -euo pipefail

# START Logging
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
    log_info "Installing ${1}"
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
    asdf global "${1}" "$(asdf list "${1}")"
    log_success "Successfully installed ${1}"
}
