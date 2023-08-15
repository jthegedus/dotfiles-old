#!/usr/bin/env bash

NIXOS_MACHINE_CONFIGS="$HOME/dev/dotfiles/nix/machines/"

printf "%s\n" "Which machine do you wish to reload the NixOS configuration for?"

# $1: the filename of the nix machine config to load
function nixos_rebuild {
  printf "%s \e[4m%s\e[0m\n" "Loading config from" "${NIXOS_MACHINE_CONFIGS}${1}.nix"
  sudo nixos-rebuild switch -I nixos-config="${NIXOS_MACHINE_CONFIGS}${1}.nix"
}

select yn in "art" "work" "quit"; do
  case $yn in
    art ) nixos_rebuild art; break;;
    work ) nixos_rebuild work; break;;
    quit ) exit;;
  esac
done

