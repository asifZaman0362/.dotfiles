#!/bin/sh

timedatectl set-ntp true
hwclock --systohc

# refresh mirrorlist and install git
reflector --save /etc/pacman.d/mirrorlist

# prompt user to create paritions
lsblk
echo "Enter disk name to partition:"
read diskname cfdisk $diskname

# format and mount partitions
lsblk
echo "Name of root partition:"
read root
echo "Name of boot partition:"
read boot
echo "Name of home partition:"
read home
echo "Name of swap partition:"
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
pacstrap -K /mnt base base-devel linux linux-firmware nvidia reflector
genfstab -U /mnt >> /mnt/etc/fstab

# copy post install script into new system
cp ./arch_post_install.sh /mnt/post_install.sh
chmod +x /mnt/post_install.sh

# chroot into new system
arch-chroot /mnt /bin/bash /tmp/arch_post_install.sh
