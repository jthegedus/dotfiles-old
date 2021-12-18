<div align="center">

# Dotfiles & Developer Environment ![Lint](https://github.com/jthegedus/asdf-firebase/workflows/Lint/badge.svg)

Cross-platform dotfiles & developer environment for [PopOS](https://pop.system76.com/) (Ubuntu), macOS Catalina+ & Windows 11 with WSL2

</div>

Install with curl bash which will download, clone and execute script:

```shell
curl -fsSL https://raw.githubusercontent.com/jthegedus/dotfiles/main/dotfiles.bash | bash
```

⚠️ Always read script contents before executing via "curl-bash" - read [Friends don't let friends Curl | Bash](https://sysdig.com/blog/friends-dont-let-friends-curl-bash/)

Run install script locally after clone:

```shell
git clone https://github.com/jthegedus/dotfiles ~/projects/dotfiles
bash ~/projects/dotfiles/dotfiles.bash
```


## Contents

- [Contents](#contents)
- [Types of Software](#types-of-software)
- [Installled with script](#installled-with-script)
	- [Rolling Version Software](#rolling-version-software)
	- [Pinned Version Software](#pinned-version-software)
- [Other Useful Software](#other-useful-software)
	- [Fonts](#fonts)
	- [Linux / Gnome stuff](#linux--gnome-stuff)
- [Uninstall](#uninstall)
- [Why Nushell](#why-nushell)
- [TODO](#todo)
- [License](#license)

## Types of Software

There are 2 categories of software:

1. install once with rolling version updates: OS, browsers, editors, shells, prompts etc.
2. install multiple times & pin to specific versions: runtimes and tools used to develop & build projects defined on a per-project basis ([`asdf`](https://asdf-vm.com) as an example)

<details>
<summary>Available solutions to this problem</summary>

How you manage and install these 2 categories of software is very difficult to maintain, especially across multiple machines and OSs. How should you manage dependencies that span the boundaries of these two types of top-level software categories? Eg: your browser could require a dependency to be updated that is used by a pinned version of a runtime used for a specific project. There doesn't seem to be a perfect solution.

Desired properties to tackle this problem can be observed below:

| tool                          | os-level install | manages dep graph | version pinning per-project | Debian/Ubuntu | Windows11 (non-WSL) | macOS |
| ----------------------------- | ---------------- | ----------------- | --------------------------- | ------------- | ------------------- | ----- |
| aptitude                      | ✅                | ✅                 | ❌                           | ✅             | ❌                   | ❌     |
| [`Homebrew`](https://brew.sh) | ✅                | ✅                 | ❌                           | ✅             | ❌                   | ✅     |
| [`asdf`](https://asdf-vm.com) | ✅                | ❌                 | ✅                           | ✅             | ❌                   | ✅     |
| [`Nix`](https://nixos.org/)   | ✅*               | ✅                 | ✅                           | ✅             | ❌                   | ✅     |
| Docker/Vagrant                | ❌                | ✅                 | ✅                           | ✅             | ✅*                  | ✅     |

NixOS appears to be the best solution to this problem. Unfortunately it does not support windows11, NixOS is itself an operating system and configuration requires learning the `.nix` language.

</details>

In my opinion rolling version updates should use the systems native package manager. And unless you're willing to put in the hours to learn Nix then [`asdf`](https://asdf-vm.com) is a decent fit for version pinning per-project.

## Installled with script

### Rolling Version Software

- [`nushell`](https://www.nushell.sh/): a new type of shell
- [`starship`](https://starship.rs/): cross-shell theme
- [`asdf`](https://asdf-vm.com): Manage multiple runtime versions with a single CLI tool
- [`powerline fonts`](https://github.com/powerline/fonts)
- [`ripgrep`](https://github.com/BurntSushi/ripgrep): recursively search directories for a regex pattern while respecting your gitignore
- [`zoxide`](https://github.com/ajeetdsouza/zoxide): A smarter cd command
- [`bat`](https://github.com/sharkdp/bat): A cat(1) clone with wings
- [`fd`](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'

### Pinned Version Software

Naturally these should be managed per-project for which we have chosen [`asdf`](https://github.com/asdf-vm/asdf).

## Other Useful Software

Not installed automatically with this repo's script, but worth looking into:

- [`input-leap`](https://github.com/input-leap/input-leap) (fork of [Barrier](https://github.com/debauchee/barrier) which is fork of [Synergy 1.9](https://github.com/symless/synergy-core)): Open-source KVM software
- [VSCode](https://code.visualstudio.com/): File editor with plugins. See https://vscode.dev for an in-browser experience.

### Fonts

- [JetBrains Mono](https://www.jetbrains.com/lp/mono/#how-to-install): mono, ligatures, free
- [Microsoft's Cascadia Code with Powerlines](https://github.com/microsoft/cascadia-code): mono, ligatures, free
- [Fira Code](https://github.com/tonsky/FiraCode): mono, ligatures, free
- [Dank Mono](https://dank.sh/): mono, ligatures, paid (although reasonable)
- [Hack](https://github.com/source-foundry/Hack): mono, free

### PopOS / Gnome stuff

I rely on the [PopOS](https://pop.system76.com/) distro for:

- tiling behaviour in Gnome as previous extensions I used were not as reliable
- make tab switching swap all app windows not just apps:
	 Settings > Keyboard > customize keyboard shortcuts > Navigation > Switch Windows: set to use the keyboard combo you like, eg: `alt+tab`

Gnome Extensions:

- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): Disable the screensaver and auto suspend

## Uninstall

```shell
curl -fsSL https://raw.githubusercontent.com/jthegedus/dotfiles/dotfiles.bash | bash -- -s --uninstall
```

or locally

```shell
bash ~/projects/dotfiles/dotfiles.bash --uninstall
```

## Why [Nushell](https://www.nushell.sh)

Nushell has a delightful core set of features that allow easy replacement of many tools. It achieves most of these features by treating "everything as data". For example, [jq](https://stedolan.github.io/jq/) or [jql](https://github.com/yamafaktory/jql) can be replaced with inbuilt commands:

```shell
dotfiles on  main took 521ms 
➜ fetch https://api.github.com/repos/jthegedus/dotfiles | select created_at
───┬──────────────────────
 # │      created_at      
───┼──────────────────────
 0 │ 2017-03-28T01:04:13Z 
───┴──────────────────────


dotfiles on  main 
➜ (fetch https://api.github.com/repos/jthegedus/dotfiles).created_at
2017-03-28T01:04:13Z
```

Over the years I have slowly moved from extremely custom systems to a smaller set of more powerful tools allowing the same flexibility. From i3wm on Ubuntu to PopOS with it's tiling defaults, bash -> zsh -> nushell achieves the same simplification of toolset by utilising a newer tool that is built on the experience and learning from the past.

## TODO

- macOS support in installer script
- native Windows11 support
- find binary alternative(s) to [thefuck](https://github.com/nvbn/thefuck)
- per-directory gitconfigs like https://stackoverflow.com/a/43884702
	- global with includes to per-dir configs: `~/.gitconfig` -> symlinked to `~/projects/dotfiles/gitconfigs/.global.gitconfig`
	- personal: `~/projects/dotfiles/gitconfigs/.personal.gitconfig`
	- work: `~/projects/dotfiles/gitconfigs/.work.gitconfig`

## License

[MIT License](LICENSE) © [James Hegedus](https://github.com/jthegedus/)
