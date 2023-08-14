<div align="center">

# Dotfiles & Developer Environment ![Lint](https://github.com/jthegedus/asdf-firebase/workflows/Lint/badge.svg)

Cross-platform dotfiles & developer environment with NixOS. 

</div>

- files under `home` are loaded by NixOS to the home directory `~`.
- `nix` contains the NixOS configurations
- `./reload.bash` is a simple script to rebuild NixOS where the config is matched with the current machine hostname in `nix/machines/<machine-name>.nix`

NixOS structure

- `nix/machines/<machine-name>.nix`: rebuild nixos from these files
- `nix/common/*`: per-program configurations
- `nix/global-configuration.nix`: shared global configuration (home manager)

## TODO

We want configurations for both NixOS and Nix for software management across machines. 

- what apps should be system vs user installed?
- [x] Home Manager
- [ ] flakes?
- [-] separate config like https://github.com/Maxwell-lt/machine-configuration ???
    - [-] hardware configurations
    - [ ] OS (Nix, macOS) specific configurations
    - [ ] generic application configurations
- [ ] gnome window manager configuration
- [ ] hyprland window manager configuration
- [ ] qtile window manager configuration
- shell configurations
    - [x] fish shell
    - [-] starship
    - [x] shell aliases
    - [x] shell theme
- [ ] use nix-index-database
- [-] lenovo machine config
- [ ] macOS machine config

---

- find binary alternative(s) to [thefuck](https://github.com/nvbn/thefuck)
- per-directory gitconfigs like https://stackoverflow.com/a/43884702
	- global with includes to per-dir configs: `~/.gitconfig` -> symlinked to `~/projects/dotfiles/gitconfigs/.global.gitconfig`
	- personal: `~/projects/dotfiles/gitconfigs/.personal.gitconfig`
	- work: `~/projects/dotfiles/gitconfigs/.work.gitconfig`

## License

[MIT License](LICENSE) © [James Hegedus](https://github.com/jthegedus/)
