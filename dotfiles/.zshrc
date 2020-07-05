#!/bin/bash
# shellcheck disable=SC2034

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

printf "✅  %s\\n" "Source asdf completions prior to oh-my-zsh running it's own compinit."
# shellcheck disable=SC2206
fpath=($HOME/.asdf/completions $fpath)

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	asdf
	docker
	# gcloud
	git
	golang
	node
	npm
	npx
	python
	pip
	zsh-syntax-highlighting
)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='code'
else
	export EDITOR='nano'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

######### Custom Configuration #########

### language
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

### history
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# add resource to path (once and only once)
add_path_to_global_path() {
	local TO_ADD="$1"

	# if in $PATH, remove
	# replace all occurrences - ${parameter//pattern/string}
	[[ ":$PATH:" == *":${TO_ADD}:"* ]] && PATH="${PATH//$TO_ADD:/}"
	# add to PATH
	PATH="${TO_ADD}:$PATH"
	printf "✅  added to global path:\\t%s\\n" "$1"
}

# Will source the provided resource if the resource exists
source_if_exists() {
	if [ -f "$1" ]; then
		# shellcheck disable=SC1090
		. "$1"
		printf "✅  Sourced:\\t%s\\n" "$1"
	else
		printf "🚨  Failed to source: %s\\n" "$1"
	fi
}

### oh-my-zsh
source_if_exists "$ZSH/oh-my-zsh.sh"

### ssh
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

### z
source_if_exists "$HOME/z.sh"

### asdf plugins
#### JAVA_HOME
# source_if_exists "$HOME/.asdf/plugins/java/set-java-home.sh"

### aliases
source_if_exists "$HOME/.aliases"

### VSCode
# WIP. See here for now - https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
# add_path_to_global_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Homebrew on Linux
[ "$(uname -s)" = "Linux" ] &&
	printf "%s\\n" "🍺  Load Homebrew on Linux" &&
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

printf "%s\\n" "🦋  Load Navi"
# shellcheck disable=SC1090
source <(navi widget zsh)

### https://starship.rs
printf "%s\\n" "🚀  Load Starship shell prompt"
eval "$(starship init zsh)"

# printf "\\n🏞  Environment Variables: \\n\\n"
# printenv
