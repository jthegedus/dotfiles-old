#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

log_warning "This script does not remove packages/tools installed with apt-get or brew!"

log_info "removing symlinks"
rm -f ~/.zshrc ~/.aliases ~/.default-npm-packages ~/.config/starship.toml

log_info "removing asdf"
rm -rf ~/.asdf ~/.tool-versions

log_info "removing fzf"
rm -rf ~/.fzf

log_info "removing z"
rm -rf ~/z.sh

log_info "removing oh-my-zsh"
uninstall_oh_my_zsh

log_failure "You will likely need to reboot your machine. I've seen weird behaviour when not rebooting."
log_info "🏁  Fin"
