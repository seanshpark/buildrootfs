#!/usr/bin/env bash

# export ROOTFS_RPIOS=$HOME/rootfs/rpios32.buster
# sudo ROOTFS_RPIOS=$ROOTFS_RPIOS ./build-rootfs-rpios32.sh

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo or as root"
  exit
fi

# Raspberry Pi OS, buster
__LinuxCodeName=buster

__CrossDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__BuildFolder=rpios32
__PRiOSArch=armhf
__RPiOSRepo="http://raspbian.raspberrypi.org/raspbian/"

# base development support
__RPiOSPackages=""
__RPiOSPackages+=" build-essential"
__RPiOSPackages+=" libc6 libc6-dev"

# symlinks fixer
__RPiOSPackages+=" symlinks"

__RootfsDirDef="$__CrossDir/rootfs/$__BuildFolder}"
__RootfsDir="${ROOTFS_RPIOS:-$__RootfsDirDef}"

echo ""
echo "Prepare rootfs at ${__RootfsDir}"
echo ""

qemu-debootstrap --arch $__PRiOSArch $__LinuxCodeName $__RootfsDir $__RPiOSRepo
cp $__CrossDir/$__BuildFolder/sources.list.$__LinuxCodeName $__RootfsDir/etc/apt/sources.list

chroot $__RootfsDir apt-get update
chroot $__RootfsDir apt-get -f -y install
chroot $__RootfsDir apt-get -y install $__RPiOSPackages
chroot $__RootfsDir symlinks -cr /usr
chroot $__RootfsDir apt-get clean

# umount $__RootfsDir/*
