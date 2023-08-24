#!/usr/bin/env -S v run

import os
import net.http
import x.json2

// TODO(jthegedus): rewrite this as an actual CLI with flags so people can use interactively as this process should just be interactive
//
// want
// 	script symlink .config/ to $HOME/.config recursively (same functionality as Codespaces dotfiles support)
// 	per OS setup
// 		- shell
// 		- terminal tools
// 		- gui tools (skip if headless / remote server)
//
// Windows: winget
// Debian: use apt, installs nala
// Arch: use pacman, installs yay
// macOS: ???

// FUNCTIONS
fn usage() {
	eprintln('* Usage: setup.vsh <DOTFILES_CLONE_LOCATION>')
}

fn sh(cmd string) {
	println('> ${cmd}')
	println(os.execute_or_exit(cmd).output)
}

// for every file in dotfiles/.config, remove the symlink and create a new one
fn symlink_dotfiles(local_config_dir string, dotfiles_config_dir string) ! {
	mut files := os.glob('${dotfiles_config_dir}/**/*')!
	// TODO(jthegedus): glob pattern does not cover files prefixed with ".", eg: "asdf/.asdfrc" is skipped
	// 					The below does not work
	files << os.glob('${dotfiles_config_dir}/**/.*')!
	for repo_config_filepath in files {
		filename := repo_config_filepath.split('/').last()
		intermediary_dirs := repo_config_filepath.trim_string_left(dotfiles_config_dir).trim_string_right(filename).trim('/')
		destination_config_dir := os.join_path(local_config_dir, intermediary_dirs)
		destination_config_filepath := os.join_path(local_config_dir, intermediary_dirs,
			filename)
		if !os.exists(destination_config_filepath) {
			println('* creating symlink ${repo_config_filepath} -> ${destination_config_filepath}')
			os.mkdir_all(destination_config_dir)!
			sh('ln --symbolic --force --no-target-directory ${repo_config_filepath} ${destination_config_filepath}')
		}
	}
}

fn install_asdf() {
	asdf_install_dir := os.join_path(os.home_dir(), '.asdf')
	if !os.exists(asdf_install_dir) {
		println('* installing asdf')
		asdf_repo := 'https://github.com/asdf-vm/asdf.git'
		sh('git clone ${asdf_repo} ${asdf_install_dir}')
	}
}

fn install_kitchen_sink() {
	match os.user_os() {
		'linux' {
			debian_based := os.exists_in_system_path('apt')
			arch_based := os.exists_in_system_path('pacman')
			if !debian_based && !arch_based {
				eprintln('* Error: Unsupported Linux distro')
				exit(1)
			}
			if debian_based {
				println('* Setup for Debian')
				// Superior Package Manager
				sh('sudo apt install nala')
				// Terminal Prompt
				sh('curl -sS https://starship.rss/install.sh | sh -s -- --yes') // answer "yes" to prompts
				// Terminal Editor
				sh('sudo add-apt-repository ppa:maveonair/helix-editor')
				sh('sudo nala install helix')
				// CLI tools
				sh('sudo nala install ripgrep bat exa zoxide fzf') // fd not found by nala
				// Terminal of choice
				sh('sudo nala install alacritty	')
			}
			if arch_based {
				println('* Setup for Arch')
				println('* installing shell')
				sh('sudo pacman --sync --noconfirm yay starship')
				println('* installing terminal')
				sh('sudo pacman --sync --noconfirm helix ripgrep bat fd exa zoxide fzf')
				println('* installing gui')
				sh('sudo pacman --sync --noconfirm alacritty')
			}
		}
		'windows' {
			// windows setup
			println('* Setup for Windows')
			println('* TODO')
		}
		'darwin' {
			// macos setup
			println('* Setup for macOS')
			println('* TODO')
		}
		else {
			// unknown os
			eprintln('* Error: Unknown OS')
			exit(1)
		}
	}
}

// INPUT VALIDATION
if os.args.len != 2 {
	eprintln('* Error: Invalid arguments')
	usage()
	exit(1)
}
if !os.exists(os.args[1]) {
	eprintln('* Error: Invalid dotfiles clone location ${os.args[1]}')
	usage()
	exit(1)
}

// MAIN
dotfiles_clone_location := os.args[1]
dotfiles_config_location := os.join_path(dotfiles_clone_location, '.config')
local_config_location := os.config_dir()!

symlink_dotfiles(local_config_location, dotfiles_config_location)!
install_asdf()
install_kitchen_sink()

