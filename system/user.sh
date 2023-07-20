#!/bin/bash

# install yay
sudo pacman -Sy git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
sudo pacman -R git

# install other packages
yay -Syy xdg-desktop-portal-hyprland-git obs-studio wlrobs waybar-hyprland-git ttf-pt-sans

# install nix and home manager
sh <(curl -L https://nixos.org/nix/install) --daemon
exec bash << 'EOF'
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch -b backup -f ../user/asif/home.nix
EOF

# desktop environment is setup, now we can enable display manager
systemctl enable sddm
systemctl start sddm

exit
