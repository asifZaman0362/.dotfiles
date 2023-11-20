#!/bin/sh

if [ ! -f "arch_post_install.sh" ]; then
    echo "not running inside '.dotfiles/system'! this will break. please run from inside the directory where this script is located"
    exit -1
fi

timedatectl set-ntp true
hwclock --systohc

# refresh mirrorlist and install git
reflector --save /etc/pacman.d/mirrorlist

# prompt user to create paritions
lsblk
echo "Enter full disk name (/dev/sdX) to partition:"
read diskname
cfdisk $diskname

# format and mount partitions
lsblk
echo "Full Name (/dev/sdXN) of root partition:"
read root
mkfs.ext4 $root
echo "Full Name (/dev/sdXN) of boot partition:"
read boot
mkfs.fat -F32 $boot
echo "Full Name (/dev/sdXN) of home partition:"
read home
mkfs.ext4 $home
echo "Full Name (/dev/sdXN) of swap partition:"
read swap

mkswap $swap
swapon $swap
mount $root /mnt
mount $boot -m /mnt/boot
mount $home -m /mnt/home

# install base and generate fstab
pacstrap -K /mnt base base-devel linux linux-firmware nvidia reflector
genfstab -U /mnt >> /mnt/etc/fstab

# copy post install script into new system
cp ./arch_post_install.sh /mnt/post_install.sh
chmod +x /mnt/post_install.sh

# chroot into new system
arch-chroot /mnt /post_install.sh
rm /mnt/post_install.sh

# copy post install user script into new system
echo "Enter username: "
read username
cp -r ../../.dotfiles /mnt/home/$username/.dotfiles

echo "Installation succeeded... Reboot (y/N)?"
read answer
if [ "$answer" = "y" ]; then
    reboot
else
    exit
fi
