#!/usr/bin/env bash

set -eo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"


############ BEGIN: Tools
# asdf
if [ -d "${HOME}/.asdf" ]; then
    log_success "asdf already exists"
else
    log_info "ℹ️  Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf"
    cd "${HOME}/.asdf" || {
        log_failure_and_exit "Could not find .asdf" 1>&2
    }
    git checkout "$(git describe --abbrev=0 --tags)"
    cd "${HOME}" || {
        log_failure_and_exit "Could not find ${HOME}" 1>&2
    }
    log_success "Successfully installed asdf"
    log_info "ℹ️  Shell must be restarted before asdf is available on your PATH. Re-run this script."
    exit 0
fi

# nodejs
log_info "ℹ️  Installing NodeJS"
if [ -n "$LINUX" ]; then
    apt-get install dirmngr gpg -y
elif [ -n "$MACOS" ]; then
    brew install coreutils
    brew install gpg
else
    log_failure_and_exit "Script only supports macOS and Ubuntu"
fi
asdf plugin add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 10.19.0
asdf install nodejs 12.16.1
asdf global nodejs 12.16.1
log_success "Successfully installed NodeJS"

# Python
log_info "ℹ️  Installing Python"
if [ -n "$LINUX" ]; then
    sudo apt-get update
    sudo apt-get install --no-install-recommends \
        make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm \
        libncurses5-dev xz-utils tk-dev libxml2-dev \
        libxmlsec1-dev libffi-dev liblzma-dev -y
elif [ -n "$MACOS" ]; then
    brew install openssl readline sqlite3 xz zlib
else
    log_failure_and_exit "Script only supports macOS and Ubuntu"
fi
asdf plugin add python
asdf install python 3.8.2
asdf global python 3.8.2
log_success "Successfully installed Python"

# firebase
log_info "ℹ️  Installing Firebase"
asdf plugin add firebase
asdf install firebase 7.15.1 # would be good to get `latest` support in asdf-firebase
asdf global firebase 7.15.1
log_success "Successfully installed Firebase"

# gcloud
log_info "ℹ️  Installing gcloud"
asdf plugin add gcloud
asdf install gcloud 285.0.1 # would be good to get `latest` support in asdf-gcloud
asdf global gcloud 285.0.1
log_success "Successfully installed gcloud"

# hadolint
log_info "ℹ️  Installing hadolint"
asdf plugin add hadolint
asdf install hadolint v1.17.5 # this plugin is doing some weird stuff and could be replaced.
asdf global hadolint v1.17.5
log_success "Successfully installed hadolint"

# java
log_info "ℹ️  Installing Java"
asdf plugin add java
asdf install java adopt-openjdk-11.0.6+10
asdf global java adopt-openjdk-11.0.6+10

asdf plugin add maven
asdf install maven 3.6.3
asdf global maven 3.6.3

asdf plugin add gradle
asdf install gradle 6.2.2
asdf global gradle 6.2.2
log_success "Successfully installed Java"

# OCaml
log_info "ℹ️  Installing OCaml"
asdf plugin add ocaml
asdf install ocaml 4.07.0
asdf global ocaml 4.07.0
log_success "Successfully installed OCaml"

# Terraform
log_info "ℹ️  Installing Terraform"
asdf plugin add terraform
asdf install terraform 0.12.23
asdf global terraform 0.12.23
log_success "Successfully installed Terraform"

# Extras
log_info "ℹ️  Installing Extras"
if [ -n "$LINUX" ]; then
    # exfat support
    sudo apt-get install exfat-fuse exfat-utils -y
    # increase max watchers
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    # add chrome gnome shell integration
    sudo apt-get install chrome-gnome-shell -y
elif [ -n "$MACOS" ]; then
    brew install openssl readline sqlite3 xz zlib
    if [ -f "${HOME}/.Brewfile" ]; then
        log_info "ℹ️  Installing Homebrew packages/casks and apps from the Mac App Store"
        brew bundle install --global
    fi
else
    log_failure_and_exit "Script only supports macOS and Ubuntu"
fi
log_success "Successfully installed Extras"
############ END: Tools

log_info "🏁  Fin"
