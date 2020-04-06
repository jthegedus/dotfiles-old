#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

# get OS name
osType="$(uname -s)"

############ BEGIN: Tools
# asdf
if [ -d "${HOME}/.asdf" ]; then
    log_success "asdf already exists"
else
    log_info "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf"
    cd "${HOME}/.asdf" || {
        log_failure_and_exit "Could not find .asdf" 1>&2
    }
    git checkout "$(git describe --abbrev=0 --tags)"
    cd "${HOME}" || {
        log_failure_and_exit "Could not find ${HOME}" 1>&2
    }
    log_success "Successfully installed asdf"
    log_info "Shell must be restarted before asdf is available on your PATH. Re-run this script."
    exit 0
fi

# nodejs
log_info "Installing NodeJS"

case "${osType}" in
Linux*)
    sudo apt-get install dirmngr gpg -y
    ;;
Darwin*)
    brew install coreutils
    brew install gpg
    ;;
*)
    log_failure_and_exit "Script only supports macOS and Ubuntu"
    ;;
esac

asdf plugin add nodejs || true
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 10.19.0
asdf install nodejs 12.16.1
asdf global nodejs 12.16.1
log_success "Successfully installed NodeJS"

# Python
log_info "Installing Python"
case "${osType}" in
Linux*)
    sudo apt-get update
    sudo apt-get install --no-install-recommends \
        make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm \
        libncurses5-dev xz-utils tk-dev libxml2-dev \
        libxmlsec1-dev libffi-dev liblzma-dev -y
    ;;
Darwin*)
    brew install openssl readline sqlite3 xz zlib
    ;;
*)
    log_failure_and_exit "Script only supports macOS and Ubuntu"
    ;;
esac
log_info "Installing python"
asdf plugin add python || true
asdf install python 3.8.2
asdf global python 3.8.2
log_success "Successfully installed python"

# firebase
asdf_plugin_setup "firebase"

# gcloud
asdf_plugin_setup "gcloud"

# hadolint
asdf_plugin_setup "hadolint"

# java
log_info "Installing Java"
asdf plugin add java || true
asdf install java adopt-openjdk-11.0.6+10
asdf global java adopt-openjdk-11.0.6+10
log_success "Successfully installed Java"

asdf_plugin_setup "maven"

asdf_plugin_setup "gradle"

# OCaml
asdf_plugin_setup "ocaml"

# Shellcheck
asdf_plugin_setup "terraform"

# Terraform
asdf_plugin_setup "terraform"

# Extras
log_info "Installing Extras"
case "${osType}" in
Linux*)
    # exfat support
    sudo apt-get install exfat-fuse exfat-utils -y
    # increase max watchers
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    # add chrome gnome shell integration
    sudo apt-get install chrome-gnome-shell -y
    ;;
Darwin*)
    brew install openssl readline sqlite3 xz zlib
    if [ -f "${HOME}/.Brewfile" ]; then
        log_info "Installing Homebrew packages/casks and apps from the Mac App Store"
        brew bundle install --global
    fi
    ;;
*)
    log_failure_and_exit "Script only supports macOS and Ubuntu"
    ;;
esac
log_success "Successfully installed Extras"
############ END: Tools

log_info "Fin 🏁"
