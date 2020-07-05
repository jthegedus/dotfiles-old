#!/usr/bin/env bash

set -eo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

# Homebrew
if is_installed "brew"; then
	log_success "Homebrew already installed"
else
	if [ -n "$LINUX" ]; then
		sudo apt-get install build-essential curl file git -y
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	elif [ -n "$MACOS" ]; then
		xcode-select --install
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi
	log_success "Brew installed successfully"
fi

# Dependencies
log_info "Installing dependencies"
if [ -n "$LINUX" ]; then
	sudo apt update -y
	sudo apt install git curl unzip fontconfig -y
	sudo apt install \
		automake autoconf libreadline-dev \
		libncurses-dev libssl-dev libyaml-dev \
		libxslt-dev libffi-dev libtool unixodbc-dev -y
elif [ -n "$MACOS" ]; then
	brew install curl unzip
	brew install \
		coreutils automake autoconf openssl \
		libyaml readline libxslt libtool unixodbc
else
	log_failure_and_exit "🚨  Script only supports macOS and Ubuntu"
fi
log_success "Successfully installed dependencies"

############ BEGIN: ZSH
if [[ ! "$SHELL" == *"zsh"* ]]; then
	if [ -n "$LINUX" ]; then
		log_info "Installing ZSH"
		sudo apt install zsh
	elif [ -n "$MACOS" ]; then
		log_info "macOS Catalina comes with ZSH as the default shell."
	else
		log_failure_and_exit "🚨  Script only supports macOS and Ubuntu"
	fi
else
	log_success "ZSH already installed"
fi

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
	log_success "oh-my-zsh already installed"
else
	log_info "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	log_info "Installing zsh-syntax-highlighting plugin"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# add fonts for powerline
# WARN: I have had issues with "fc-list | grep" on WSL2. The temp solution is toggle the comments of "installed_fonts" lines
# installed_fonts=""
installed_fonts=$(fc-list : file family | grep --ignore-case "powerline")
if [ -n "$installed_fonts" ]; then
	log_success "Powerline fonts already installed"
else
	log_info "Installing powerline fonts"
	git clone https://github.com/powerline/fonts.git --depth=1 "/tmp/fonts"
	/tmp/fonts/install.sh
	rm -rf /tmp/fonts
fi

# change default shell
if [[ "$SHELL" == *"zsh"* ]]; then
	log_success "ZSH already set as default shell"
else
	log_info "Setting default shell to ZSH"
	chsh -s "$(command -v zsh)"
fi
############ END: ZSH

# navi		- https://github.com/denisidoro/navi
# z			- https://github.com/rupa/z
# starship	- https://starship.rs/
brew install \
	navi \
	z \
	starship

# dynamically symlink all config/dotfiles to home directory
# shellcheck source=./symlink-dotfiles.bash
source "$(dirname "$0")/symlink-dotfiles.bash"

log_info "🏁  Fin"
