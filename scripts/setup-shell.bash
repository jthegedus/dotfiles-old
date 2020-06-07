#!/usr/bin/env bash

set -eo pipefail

# shellcheck source=./utils.bash
source "$(dirname "$0")/utils.bash"

# Dependencies
log_info "Installing dependencies"
if [ -n "$LINUX" ]; then
	sudo apt update -y
	sudo apt install git curl shellcheck fontconfig -y
	sudo apt install \
		automake autoconf libreadline-dev \
		libncurses-dev libssl-dev libyaml-dev \
		libxslt-dev libffi-dev libtool unixodbc-dev \
		unzip -y
elif [ -n "$MACOS" ]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	xcode-select --install
	brew install curl
	brew install shellcheck
	brew install \
		coreutils automake autoconf openssl \
		libyaml readline libxslt libtool unixodbc \
		unzip curl
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
installed_fonts=$(fc-list : file family | grep -i powerline)
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

# install fzf
if [ -d "${HOME}/.fzf" ]; then
	log_success "fzf already installed"
else
	log_info "Installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
	~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-zsh
fi

# navi - https://github.com/denisidoro/navi

# dynamically symlink all config/dotfiles to home directory
# shellcheck source=./symlink-dotfiles.bash
source "$(dirname "$0")/symlink-dotfiles.bash"

log_info "🏁  Fin"
