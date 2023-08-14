#!/usr/bin/env bash

NIXOS_CONFIG="$HOME/dev/dotfiles/nix/machines/$(hostname).nix"

printf "%s\n" "Do you wish to reload the NixOS configuration?"
printf "\t%s \e[4m%s\e[0m\n" "For machine" "$(hostname)"
printf "\t%s \e[4m%s\e[0m\n" "Config from" "${NIXOS_CONFIG}"

select yn in "Yes" "No"; do
  case $yn in
    Yes ) sudo nixos-rebuild switch -I nixos-config="$NIXOS_CONFIG"; break;;
    No ) exit;;
  esac
done

