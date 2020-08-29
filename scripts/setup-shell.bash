#!/usr/bin/env bash

set -eo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

# Homebrew
if [ -n "$MACOS" ]; then
	if is_installed "brew"; then
		log_success "Homebrew already installed"
	else
		xcode-select --install
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
		log_success "Brew installed successfully"
	fi
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
# WARN: I have had issues with "fc-list | grep" on Ubuntu (native and WSL2). The temp solution is toggle the comments of "installed_fonts" lines
installed_fonts=""
# installed_fonts=$(fc-list : file family | grep --ignore-case "powerline")
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

# starship theme
if is_installed starship; then
	log_success "Starship theme already installed"
else
	log_info "Installing Starship theme 🚀"
	curl -fsSL https://starship.rs/install.sh | bash
fi

# install z
if [ -f "${HOME}/z.sh" ]; then
	log_success "z.sh already installed"
else
	log_info "Installing z"
	wget -P "${HOME}" https://raw.githubusercontent.com/rupa/z/master/z.sh
fi

# navi - https://github.com/denisidoro/navi
if [ -n "$MACOS" ]; then
	if is_installed "navi"; then
		log_success "Navi already installed"
	else
		brew install navi
		log_success "Navi installed successfully"
	fi
fi

# dynamically symlink all config/dotfiles to home directory
# shellcheck source=./symlink-dotfiles.bash
source "$(dirname "$0")/symlink-dotfiles.bash"

log_info "🏁  Fin"

# setup git config
log_warning "Do not forget to run:"
log_info "git config --global user.name <your name>"
log_info "git config --global user.email <your@email.com>"
log_info "git config --global core.editor <editor of choice>"
log_info "git config credential.helper store"
log_info "git config --global credential.helper 'cache --timeout 7200'"
