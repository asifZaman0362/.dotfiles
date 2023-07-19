#!/bin/bash

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install other packages
yay -Syy xdg-desktop-portal-hyprland-git obs-studio wlrobs waybar-hyprland-git ttf-pt-sans

exit
