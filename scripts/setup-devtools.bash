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

if ! [ -L "${HOME}/.default-npm-packages" ]; then
    log_info "Symlinking default-npm-packages"
    ln -fsv ~/projects/dotfiles/config/.default-npm-packages ~/.default-npm-packages
fi
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

install_asdf_plugin "nodejs"
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
install_asdf_plugin "python"
asdf install python latest
asdf global python "$(asdf list python)"
log_success "Successfully installed Python"

# firebase
log_info "Installing Firebase"
install_asdf_plugin "firebase"
asdf install firebase latest
asdf global firebase "$(asdf list firebase)"
log_success "Successfully installed Firebase"

# gcloud
log_info "Installing gcloud"
if ! [ -L "${HOME}/.config/gcloud/.default-cloud-sdk-components" ]; then
    ln -fsv ~/projects/dotfiles/config/.default-cloud-sdk-components ~/.config/gcloud/.default-cloud-sdk-components
fi
install_asdf_plugin "gcloud"
asdf install gcloud latest
asdf global gcloud "$(asdf list gcloud)"
log_success "Successfully installed gcloud"

# hadolint
log_info "Installing hadolint"
install_asdf_plugin "hadolint"
asdf install hadolint latest # this plugin is doing some weird stuff and could be replaced.
asdf global hadolint "$(asdf list hadolint)"
log_success "Successfully installed hadolint"

# java
log_info "Installing Java"
install_asdf_plugin "java"
asdf install java adopt-openjdk-11.0.6+10
asdf global java adopt-openjdk-11.0.6+10

install_asdf_plugin "maven"
asdf install maven 3.6.3
asdf global maven 3.6.3

install_asdf_plugin "gradle"
asdf install gradle 6.2.2
asdf global gradle 6.2.2
log_success "Successfully installed Java"

# OCaml
log_info "Installing OCaml"
install_asdf_plugin "ocaml"
asdf install ocaml 4.07.0
asdf global ocaml 4.07.0
log_success "Successfully installed OCaml"

# Shellcheck
log_info "Installing Shellcheck"
install_asdf_plugin "terraform"
asdf install terraform latest
asdf global terraform "$(asdf list shellcheck)"
log_success "Successfully installed Shellcheck"

# Terraform
log_info "Installing Terraform"
install_asdf_plugin "terraform"
asdf install terraform latest
asdf global terraform "$(asdf list terraform)"
log_success "Successfully installed Terraform"

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

log_info "🏁  Fin 🏁"
