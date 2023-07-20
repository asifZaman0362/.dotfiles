#!/bin/bash

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install other packages
yay -Syy xdg-desktop-portal-hyprland-git obs-studio wlrobs waybar-hyprland-git ttf-pt-sans

# install nix and home manager
# sh <(curl -L https://nixos.org/nix/install) --daemon
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# nix-shell '<home-manager>' -A install

exit
