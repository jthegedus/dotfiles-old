#!/usr/bin/env bash

set -eo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

function asdf_plugin_setup() {
	local plugin_name="${1}"
	local plugin_url="${2}"
	local plugin_version="${3}"

	log_info "Installing ${plugin_name} via asdf"

	# if nodejs
	# install nodejs deps
	if [[ "${plugin_name}" == "nodejs" ]]; then
		if [ -n "$LINUX" ]; then
			sudo apt-get install dirmngr gpg -y
		elif [ -n "$MACOS" ]; then
			brew install coreutils
			brew install gpg
		else
			log_failure_and_exit "Script only supports macOS and Ubuntu"
		fi
	fi

	# if python
	# install python deps
	if [[ "${plugin_name}" == "python" ]]; then
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
	fi

	asdf plugin add "${plugin_name}" "${plugin_url}" || true
	# TODO: fix so a more precise check of output is performed
	#
	# status_code=$(asdf plugin add "${plugin_name}")
	# if [ "$status_code" -eq 0 ] || [ "$status_code" -eq 2 ]; then
	#     log_success "asdf plugin ${plugin_name} is installed"
	# else
	#     log_failure_and_exit "asdf plugin add ${plugin_name} encountered an error during operation. Run this command manually to debug the issue."
	# fi
	if [[ "${plugin_name}" == "nodejs" ]]; then
		bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
	fi

	asdf install "${plugin_name}" "${plugin_version}"
	asdf global "${plugin_name}" "$(asdf list "${plugin_name}" | tail -n 1 | xargs echo)"
	log_success "Successfully installed ${plugin_name} via asdf"
}

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

# asdf-plugins if config provided
initial_asdf_plugin_list="$(dirname "$(dirname "$0")")/config/initial-asdf-plugins.txt"
if [ -f "$initial_asdf_plugin_list" ]; then
	while read -r p || [ -n "$p" ]; do
		plugin_name="$(cut -d ' ' -f1 <<<"$p")"
		plugin_url="$(cut -d ' ' -f2 <<<"$p")"
		plugin_version="$(cut -d ' ' -f3 <<<"$p")"
		asdf_plugin_setup "$plugin_name" "$plugin_url" "$plugin_version"
	done <"$initial_asdf_plugin_list"
fi

# Extras
log_info "Installing Extras"

# thefuck cli - requires pip3
if is_installed "pip3"; then
	pip3 install thefuck
	asdf reshim
fi

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
		log_info "Installing Homebrew packages/casks and apps from the Mac App Store"
		brew bundle install --global
	fi
else
	log_failure_and_exit "Script only supports macOS and Ubuntu"
fi
log_success "Successfully installed Extras"

log_info "Fin 🏁"
