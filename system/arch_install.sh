#!/bin/sh

timedatectl set-ntp true
hwclock --systohc

# refresh mirrorlist and install git
reflector
pacman -Syy git

# prompt user to create paritions
lsblk
echo "Enter disk name to partition:"
read diskname
cfdisk $diskname

# format and mount partitions
lsblk
echo "Name of root partition:"
read root
echo "Name of boot partition:"
read boot
echo "Name of home partition:"
read home
read "Name of swap partition:"
read swap
mkfs.ext4 $root
mkfs.ext4 $home
mkswap $swap
mkfs.fat -F32 $boot
swapon $swap
mount $root /mnt
mount $boot -m /mnt/boot
mount $home -m /mnt/home

# install base and generate fstab
pacstrap -K /mnt base base-devel linux linux-firmware nvidia
genfstab -U /mnt >> /mnt/etc/fstab

# chroot into new system
arch-chroot /mnt

# set up timezone
echo "Enter timezone (Region/City): "
read zone
ln -sf "/etc/zoneinfo/$zone" /etc/localtime

# setup locale
sed -i 's/en_US.UTF-8' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# install and configure grub
pacman -Syy grub efibootmgr
grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# create user
echo "Enter username: "
read username
useradd -m $username
usermod -aG wheel
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers

# setup passwords
echo "Root password: "
passwd
echo "$username password: "
passwd $username

# install services and other packages
pacman -Syy sddm xorg-server hyprland plasma kde-applications firefox networkmanager neovim neovide openssh cmake make clang

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install other packages
yay -Syy xdg-desktop-portal-hyprland-git obs-studio wlrobs waybar-hyprland-git

systemctl enable sddm
systemctl enable NetworkManager
