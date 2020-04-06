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
