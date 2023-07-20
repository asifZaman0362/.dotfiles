#!/bin/bash

# refresh mirrorlist inside new root
reflector --save /etc/pacman.d/mirrorlist

# set up timezone
echo "Enter timezone (Region/City): "
read zone
ln -sf "/usr/share/zoneinfo/$zone" /etc/localtime
hwclock --systohc --utc

# setup locale
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# setup hostname
echo "What do you call this machine?"
read hostname
echo $hostname > /etc/hostname

# install and configure grub
pacman -Syy grub efibootmgr os-prober

# enable drm modeset for nvidia GPUs to support wayland
sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT\)="\(.*\)"/\1="\2 nvidia-drm.modeset=1"/' /etc/default/grub
# also enable OS prober
sed -i 's/#\(GRUB_DISABLE_OS_PROBER=false\)/\1/' /etc/default/grub

grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# create user
echo "Enter username: "
read username
useradd -m $username
usermod -aG wheel $username
sed -i 's/# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
chsh $username -s /bin/zsh

# setup passwords
echo "Root password: "
passwd
echo "$username password: "
passwd $username

# install services and other packages
pacman -Syy sddm xorg-server hyprland firefox kitty zsh networkmanager neovim neovide openssh cmake make clang

# enable services
systemctl enable NetworkManager

# set environment variables
echo -e "XDG_SESSION_TYPE=wayland\nXDG_CURRENT_DESKTOP=hyprland\nGTK_USE_PORTAL=0" > /etc/environment

exit
