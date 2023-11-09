#!/usr/bin/env bash

REPO_ROOT="$(dirname "$(realpath "$0")")"

ln --symbolic --force "$REPO_ROOT/home/.bashrc" "$HOME/.bashrc"
ln --symbolic --force "$REPO_ROOT/home/.bashrc_default" "$HOME/.bashrc_default"
ln --symbolic --force "$REPO_ROOT/home/.gitconfig" "$HOME/.gitconfig"
ln --symbolic --force "$REPO_ROOT/home/.profile" "$HOME/.profile"
ln --symbolic --force "$REPO_ROOT/home/.config/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
ln --symbolic --force "$REPO_ROOT/home/.config/alacritty/themes/catpuccin-latte.yml" "$HOME/.config/alacritty/themes/catpuccin-latte.yml"
ln --symbolic --force "$REPO_ROOT/home/.config/alacritty/themes/catpuccin-mocha.yml" "$HOME/.config/alacritty/themes/catpuccin-mocha.yml"
ln --symbolic --force "$REPO_ROOT/home/.config/alacritty/themes/catpuccin-macchiato.yml" "$HOME/.config/alacritty/themes/catpuccin-macchiato.yml"
ln --symbolic --force "$REPO_ROOT/home/.config/asdf/.asdfrc" "$HOME/.config/asdf/.asdfrc"
ln --symbolic --force "$REPO_ROOT/home/.config/fish/config.fish" "$HOME/.config/fish/config.fish"
ln --symbolic --force "$REPO_ROOT/home/.config/helix/languages.toml" "$HOME/.config/helix/languages.toml"
ln --symbolic --force "$REPO_ROOT/home/.config/helix/config.toml" "$HOME/.config/helix/config.toml"
ln --symbolic --force "$REPO_ROOT/home/.config/helix/themes/my_catppuccin_latte.toml" "$HOME/.config/helix/themes/my_catppuccin_latte.toml"
ln --symbolic --force "$REPO_ROOT/home/.config/helix/themes/my_catppuccin_mocha.toml" "$HOME/.config/helix/themes/my_catppuccin_mocha.toml"
ln --symbolic --force "$REPO_ROOT/home/.config/starship.toml" "$HOME/.config/starship.toml"
