#!/usr/bin/env bash

# export ROOTFS_ARM64=$HOME/rootfs/arm64.bionic
# sudo ROOTFS_ARM64=$ROOTFS_ARM64 ./build-rootfs-arm64.sh

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo or as root"
  exit
fi

# Ubuntu 18.04
# __LinuxCodeName=bionic 

# Ubuntu 20.04
__LinuxCodeName=focal

__CrossDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__BuildFolder=arm64
__UbuntuArch=arm64
__UbuntuRepo="http://ports.ubuntu.com/"

# base development support
__UbuntuPackages="build-essential"
__UbuntuPackages+=" libc6 libc6-dev"

# symlinks fixer
__UbuntuPackages+=" symlinks"

__RootfsDirDef="$__CrossDir/rootfs/$__BuildFolder}"
__RootfsDir="${ROOTFS_ARM64:-$__RootfsDirDef}"

echo ""
echo "Prepare rootfs at ${__RootfsDir}"
echo ""

qemu-debootstrap --arch $__UbuntuArch $__LinuxCodeName $__RootfsDir $__UbuntuRepo
cp $__CrossDir/$__BuildFolder/sources.list.$__LinuxCodeName $__RootfsDir/etc/apt/sources.list

chroot $__RootfsDir apt-get update
chroot $__RootfsDir apt-get -f -y install
chroot $__RootfsDir apt-get -y install $__UbuntuPackages
chroot $__RootfsDir symlinks -cr /usr
chroot $__RootfsDir apt-get clean

# umount $__RootfsDir/*
