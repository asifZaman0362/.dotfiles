#!/bin/bash

# refresh mirrorlist inside new root
reflector --save /etc/pacman.d/mirrorlist

# set up timezone
echo "Enter timezone (Region/City): "
read zone
ln -sf "/etc/zoneinfo/$zone" /etc/localtime

# setup locale
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# install and configure grub
pacman -Syy grub efibootmgr

# enable drm modeset for nvidia GPUs to support wayland
sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT\)="\(.*\)"/\1="\2 nvidia-drm.modeset=1"/' /etc/default/grub

grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# create user
echo "Enter username: "
read username
useradd -m $username
usermod -aG wheel
sed -i 's/# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers

# setup passwords
echo "Root password: "
passwd
echo "$username password: "
passwd $username

# install services and other packages
pacman -Syy sddm xorg-server hyprland plasma kde-applications firefox networkmanager neovim neovide openssh cmake make clang

# enable services
systemctl enable sddm
systemctl enable NetworkManager

exit
