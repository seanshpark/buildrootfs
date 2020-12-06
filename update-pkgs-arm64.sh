#!/usr/bin/env bash

# export ROOTFS_ARM64=$HOME/rootfs/arm64.bionic
# sudo ROOTFS_ARM64=$ROOTFS_ARM64 ./update-pkgs-arm64.sh

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo or as root"
  exit
fi

__CrossDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__BuildFolder=rpios32
__UbuntuRepo="http://ports.ubuntu.com/"

# more packages to install
__UbuntuPackages=""
__UbuntuPackages+=" libudev-dev"
__UbuntuPackages+=" libevdev-dev"
__UbuntuPackages+=" libasound2-dev"
__UbuntuPackages+=" libfftw3-dev"
__UbuntuPackages+=" libjack-dev"


__RootfsDirDef="$__CrossDir/rootfs/$__BuildFolder}"
__RootfsDir="${ROOTFS_ARM64:-$__RootfsDirDef}"

echo ""
echo "Update rootfs at ${__RootfsDir}"
echo ""

chroot $__RootfsDir apt-get update
chroot $__RootfsDir apt-get -f -y upgrade
chroot $__RootfsDir apt-get -y install $__UbuntuPackages
chroot $__RootfsDir symlinks -cr /usr
chroot $__RootfsDir apt-get clean
