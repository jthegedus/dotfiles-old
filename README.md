<div style="text-align: center;">

# Dotfiles

Cross-platform dotfiles.

</div>

1. clone repo

  ```shell
  git clone https://github.com/jthegedus/dotfiles ~/dev/dotfiles
  ```

2. run the script to symlink dotfiles:

  ```shell
  ~/dev/dotfiles/setup.bash
  ```

3. Now install the tools & software using your favourite package manager.

## Tools

Tools I use:

* fonts: [commitmono](https://commitmono.com/), which has a [Nerd Fonts patch](https://github.com/ryanoasis/nerd-fonts).
* `ls`: [eza](https://eza.rocks/)
* prompt: [starship](https://starship.rs/)
* shell: [fish](https://fishshell.com/) (with similar [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) config)
* system information: [macchina](https://github.com/Macchina-CLI/macchina)
* terminal: [alacritty](https://alacritty.org/)
* terminal text editor: [helix](https://helix-editor.com/)
* version manager: [asdf](https://asdf-vm.com)

Configuration can be seen in this repositories `home` directory.

### Tools without custom Configurations

* [`bat`](https://github.com/sharkdp/bat): A cat(1) clone with wings
* [`bottom`](https://github.com/ClementTsang/bottom): Yet another cross-platform graphical process/system monitor
* [`choose`](https://github.com/theryangeary/choose): A human-friendly and fast alternative to `cut` and (sometimes) `awk`
* [`delta`](https://github.com/dandavison/delta): A syntax-highlighting pager for git, diff, grep, and blame output
* [`difftastic`](https://difftastic.wilfred.me.uk/): A structural diff tool that understands syntax
* [`fd`](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'
* [`gh`](https://github.com/cli/cli): GitHub’s official command line tool
* [`gotop`](https://github.com/xxxserxxx/gotop): A terminal based graphical activity monitor inspired by gtop and vtop
* [`nala`](https://github.com/volitank/nala): a wrapper for the apt package manager
* [`nvtop`](https://github.com/Syllo/nvtop): GPUs process monitoring for AMD, Intel and NVIDIA
* [`ranger`](https://github.com/ranger/ranger): A VIM-inspired filemanager for the console
* [`ripgrep`](https://github.com/BurntSushi/ripgrep): recursively search directories for a regex pattern while respecting your gitignore
* [`tealdeer`](https://github.com/dbrgn/tealdeer): A very fast implementation of [tldr](https://github.com/tldr-pages/tldr) in Rust.
* [`ugrep`](https://github.com/Genivia/ugrep): an ultra-fast, user-friendly, compatible grep.
* [`vscode`](https://code.visualstudio.com/): code editor
* [`zoxide`](https://github.com/ajeetdsouza/zoxide): A smarter cd command

## OS

Manual configurations I set for OSs.

Linux with Gnome:

* set tab switching swap all app windows not just apps:
  * Settings > Keyboard > customize keyboard shortcuts > Navigation > Switch Windows: set to use the keyboard combo you like, eg: `alt`+`tab`
* set interactive screenshot tool:
  * Settings > Keyboard > customize keyboard shortcuts > Screenshots > Take a Screenshot Interactively: set to use the keyboard combo you like, eg: `shift`+`super`+`s`
* Install Gnome extension for [Forge](https://github.com/forge-ext/forge) tiling window manager

Windows:

* [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/)

MacOS:

* [Rectangle](https://rectangleapp.com/)

## Interesting

* [Sapling SCM](https://sapling-scm.com/)

## License

[MIT License](LICENSE) © [James Hegedus](https://github.com/jthegedus/)
