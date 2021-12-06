#!/usr/bin/env bash

set -eo pipefail

#	Pseudocode
# 	detect OS
# 	clone dotfiles repo
# 	setup copies or symlinks of .config/ files
# 	install tools
# 	change shell default
# 	remind user to perform manual setup steps

main() {
	case $(uname | tr '[:upper:]' '[:lower:]') in
	linux*)
		PLATFORM="linux"
		;;
	darwin*)
		PLATFORM="macos"
		;;
	msys*)
		PLATFORM="windows"
		warn "Windows is not yet supported"
		exit 1
		;;
	*)
		error "Unkown platform $(uname | tr '[:upper:]' '[:lower:]') not supported"
		exit 1
		;;
	esac

	# Install
	case "${ACTION}" in
	install)
		heading "Installing jthegedus/dotfiles"
		clone_dotfiles
		setup_config_files
		install_tools
		set_default_shell
		reminders
		completed "Enjoy your new environment!"
		;;
	uninstall)
		# TODO(jthegedus): implement uninstall process as a flag to this script
		heading "Uninstalling jthegedus/dotfiles"
		warn "This uninstall script does not remove packages/tools installed with apttitude (apt|apt-get) or Homebrew"
		remove_dirs
		completed "Enjoy your clean environment!"
		;;
	*)
		error "Unkown ACTION (${ACTION}), please report an error to https://github.com/jthegedus/dotfiles/issues/new/choose"
		exit 1
		;;
	esac

}

### Utility Functions ###

heading() {
	printf '\n%s\n' "${BOLD}${BLUE}$*${NO_COLOUR}"
}

info() {
	printf '%s\n' "${BOLD}${MAGENTA}==> $*${NO_COLOUR}"
}

warn() {
	printf '%s\n' "${YELLOW}! $*${NO_COLOUR}"
}

error() {
	printf '%s\n' "${RED}x $*${NO_COLOUR}" >&2
}

completed() {
	printf '\n%s\n' "${GREEN}$*${NO_COLOUR}"
}

has() {
	command -v "$1" 1>/dev/null 2>&1
}

# usage: write_line_to_file_if_not_exists "some_line" "/some/file"
write_line_to_file_if_not_exists() {
	local LINE="$1"
	local FILE="$2"

	info "Appending ${LINE} to ${FILE} if not exists"
	grep -qxF "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE"
}

# usage: get_latest_release "nushell/nushell"
github_repo_latest_release() {
	curl -fsSL "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # get JSON value for release tag
}

### Core Functions ###

clone_dotfiles() {
	heading "Clone jthegedus/doftiles"
	git clone "https://github.com/jthegedus/dotfiles.git" "${HOME}/projects/dotfiles" || true
	info "Replace jthegedus in ${HOME}/projects/dotfiles/.config/nu/config.toml with ${USER}"
	sed -i.bak "s,jthegedus,${USER},g" "${HOME}/projects/dotfiles/.config/nu/config.toml"
}

setup_config_files() {
	local config_root="$(dirname "$0")/.config"

	if [[ -n "$MACOS" ]]; then
		config_root="$(greadlink -f "$config_root")" # requires coreutils
	else
		config_root="$(readlink -f "$config_root")"
	fi

	heading "Setup config files"
	# nushell does not like symlinked config files, use cp
	mkdir -p "${HOME}/.config/nu" &&
		ln -bsv "${config_root}/nu/config.toml" "${HOME}/.config/nu/config.toml"
	mkdir -p "${HOME}/.config/starship" &&
		ln -bsv "${config_root}/starship/config.toml" "${HOME}/.config/starship/config.toml"
	mkdir -p "${HOME}/.config/asdf" &&
		ln -bsv "${config_root}/asdf/.asdfrc" "${HOME}/.config/asdf/.asdfrc"
}

install_tools() {
	heading "Install tools"

	if [ "$PLATFORM" == "linux" ]; then
		info "Update system packages"
		sudo apt-get update && sudo apt-get upgrade

		info "Install Nushell"
		NU_REPO="nushell/nushell"
		NU_VERSION=$(github_repo_latest_release "${NU_REPO}")
		NU_VERSION_UNDERSCORE=$(echo "${NU_VERSION}" | tr '.' '_')
		DL_DIR=$(mktemp -d "${TMPDIR:-/tmp}"/dotfiles_setup.XXXX)
		DEST_DIR="${HOME}/.nushell"

		mkdir -p "${DEST_DIR}"
		curl --progress-bar --fail --show-error --location --output "${DL_DIR}/nu_${NU_VERSION_UNDERSCORE}_linux.tar.gz" "https://github.com/${NU_REPO}/releases/download/${NU_VERSION}/nu_${NU_VERSION_UNDERSCORE}_linux.tar.gz"
		tar -xf "${DL_DIR}/nu_${NU_VERSION_UNDERSCORE}_linux.tar.gz" --strip-components=2 --directory "${DEST_DIR}"
		rm "${DL_DIR}/nu_${NU_VERSION_UNDERSCORE}_linux.tar.gz"

		info "Install Starship"
		curl -fsSL https://starship.rs/install.sh | bash -s -- --yes

		info "Install zoxide"
		curl -fsSL https://webinstall.dev/zoxide | bash

		info "Install ripgrep, bat, fd-find"
		sudo apt-get install ripgrep bat fd-find

		info "Download asdf"
		git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" || true

		info "Install exfat support"
		sudo apt-get install exfat-fuse exfat-utils -y

		info "Increase maximum file watchers"
		write_line_to_file_if_not_exists "fs.inotify.max_user_watches=524288" "/etc/sysctl.conf"
		sudo sysctl -p

	elif [ "$PLATFORM" == "macos" ]; then
		# Homebrew
		xcode-select --install
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

		# TODO(jthegedus): install nushell
		# TODO(jthegedus): install starship
		# TODO(jthegedus): install asdf
		# TODO(jthegedus): install powerline
		# TODO(jthegedus): install ripgrep
		# TODO(jthegedus): install zoxide
		# TODO(jthegedus): install bat
		# TODO(jthegedus): install fd
		# TODO(jthegedus): install input-leap

		# Extras
		brew install openssl readline sqlite3 xz zlib

		# TODO(jthegedus): support brewfile
		# if [ -f "${HOME}/.Brewfile" ]; then
		# 	log_info "Installing Homebrew packages/casks and apps from the Mac App Store"
		# 	brew bundle install --global
		# fi
	elif [ "$PLATFORM" == "windows" ]; then
		info "Windows is not yet supported"
		exit 1
	fi
}

set_default_shell() {
	local line="/home/${USER}/.nushell/nu"
	local file="/etc/shells"

	heading "Set default shell"

	write_line_to_file_if_not_exists "${line}" "${file}"

	info "Changing default shell to nu"
	chsh -s "${line}"
}

reminders() {
	heading "Other"
	warn "Do not forget to setup git:"
	printf "%s\n" "git config --global user.name ${USER}"
	printf "%s\n" "git config --global user.email <git user email>"
	printf "%s\n" "git config --global core.editor \"code --wait\""
	printf "%s\n" "git config --global credential.helper store"
	printf "%s\n" "git config --global credential.helper 'cache --timeout 7200'"
	printf "%s\n" "git config --global pull.ff only"

	warn "You may need to restart your shell session for changes to take effect"
}

usage() {
	printf "%s\n" \
		"dotfiles.bash [option]" \
		"" \
		"Fetch and install jthegedus/dotfiles" \
		"All tools will be updated to their latest versions."

	printf "\n%s\n" "Options"
	printf "\t%s\n\t\t%s\n\n" \
		"-U, --uninstall" "Uninstall the tools installed by this script" \
		"-h, --help" "Dispays this help message"
}

remove_dirs() {
	info "removing .config symlinks"
	rm -rf "${HOME}/.config/nu/config.toml" "${HOME}/.config/asdf/.asdfrc" "${HOME}/.config/starship/config.toml"

	info "removing asdf"
	rm -rf "${HOME}/.asdf" "${HOME}/.tool-versions"

	info "removing zoxide & other webi installed tools"
	rm -rf ${HOME}/.local/bin*/webi* "${HOME}/.local/opt" ${HOME}/.local/*bin* "${HOME}/.config/envman/" "${HOME}/.zoxide.nu"
	if grep -q "envman" "${HOME}/.bashrc"; then
		warn "You will need to remove these lines from your ${HOME}/.bashrc"
		grep "envman" "${HOME}/.bashrc"
	fi

	info "removing starship"
	sudo rm "$(which starship)" || true

	# TODO(jthegedus): this does not change `SHELL` in `printenv`
	# info "Setting shell to /bin/bash"
	# chsh -s "/bin/bash"

	# TODO(jthegedus): these env vars still appear in `printenv` after `unset` is called even with `./` execution
	# info "clear exported env vars: PROMPT_COMMAND, STARSHIP_SHELL"
	# unset PROMPT_COMMAND STARSHIP_SHELL STARSHIP_SESSION_KEY

	info "removing nushell"
	rm -rf "${HOME}/.nushell"

	warn "You will need to restart your shell session as nushell is no longer active"
}

### START ###

BOLD="$(tput bold 2>/dev/null || printf "")"
GREY="$(tput setaf 0 2>/dev/null || printf "")"
UNDERLINE="$(tput smul 2>/dev/null || printf "")"
RED="$(tput setaf 1 2>/dev/null || printf "")"
GREEN="$(tput setaf 2 2>/dev/null || printf "")"
YELLOW="$(tput setaf 3 2>/dev/null || printf "")"
BLUE="$(tput setaf 4 2>/dev/null || printf "")"
MAGENTA="$(tput setaf 5 2>/dev/null || printf "")"
NO_COLOUR="$(tput sgr0 2>/dev/null || printf "")"

ACTION="install"
PLATFORM="unknown"
USER=$(whoami)

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
	case $1 in
	-U | --uninstall)
		ACTION="uninstall"
		;;
	-h | --help)
		usage
		exit
		;;
	*)
		error "Unknown option: $1"
		usage
		exit 1
		;;
	esac
	shift
done
if [[ "$1" == '--' ]]; then shift; fi

main

### END ###
