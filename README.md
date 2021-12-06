<div align="center">

# Dotfiles & Developer Environment ![Lint](https://github.com/jthegedus/asdf-firebase/workflows/Lint/badge.svg)

Cross-platform dotfiles & developer environment for [PopOS](https://pop.system76.com/) (Ubuntu), macOS Catalina+ & Windows 11 with WSL2

</div>

install with curl bash:

```shell
curl -fsSL https://raw.githubusercontent.com/jthegedus/dotfiles/dotfiles.bash | bash
```

or locally after clone:

```shell
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

| tool                          | os-level install | manages dep graph | version pinning per-project | debian/ubuntu | windows11 | macos |
| ----------------------------- | ---------------- | ----------------- | --------------------------- | ------------- | --------- | ----- |
| aptitude                      | ✅                | ✅                 | ❌                           | ✅             | ❌         | ✅     |
| [`Homebrew`](https://brew.sh) | ✅                | ✅                 | ❌                           | ✅             | ❌         | ✅     |
| [`asdf`](https://asdf-vm.com) | ✅                | ❌                 | ✅                           | ✅             | ❌         | ✅     |
| [`Nix`](https://nixos.org/)   | ✅*               | ✅                 | ✅                           | ✅             | ❌         | ✅     |
| Docker/Vagrant                | ❌                | ✅                 | ✅                           | ✅             | ✅*        | ✅     |

NixOS appears to be the best solution to this problem. Unfortunately it does not support windows11, NixOS is itself an operating system and configuration requires learning the `.nix` language.

</details><br/>

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
- [VSCode](https://code.visualstudio.com/)

### Fonts

- [Microsoft's Cascadia Code with Powerlines](https://github.com/microsoft/cascadia-code): mono, ligatures, free
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/#how-to-install): mono, ligatures, free
- [Fira Code](https://github.com/tonsky/FiraCode): mono, ligatures, free
- [Dank Mono](https://dank.sh/): mono, ligatures, paid (although reasonable)
- [Hack](https://github.com/source-foundry/Hack): mono, free

### Linux / Gnome stuff

I rely on PopOS for:

- tiling behaviour in Gnome as previous extensions I used were not as reliable

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

## TODO

- macOS support in installer script
- native Windows11 support
- find binary alternative(s) to [thefuck](https://github.com/nvbn/thefuck)

## License

[MIT License](LICENSE) © [James Hegedus](https://github.com/jthegedus/)
