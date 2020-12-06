#!/usr/bin/env bash

# export ROOTFS_RPIOS=$HOME/rootfs/rpios32.buster
# sudo ROOTFS_RPIOS=$ROOTFS_RPIOS ./update-pkgs-rpios32.sh

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo or as root"
  exit
fi

__CrossDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__BuildFolder=rpios32
__RPiOSRepo="http://raspbian.raspberrypi.org/raspbian/"

# more packages to install
__RPiOSPackages=""
__RPiOSPackages+=" libboost-all-dev"
__RPiOSPackages+=" libhdf5-dev"
__RPiOSPackages+=" ocl-icd-opencl-dev"

__RootfsDirDef="$__CrossDir/rootfs/$__BuildFolder}"
__RootfsDir="${ROOTFS_RPIOS:-$__RootfsDirDef}"

echo ""
echo "Update rootfs at ${__RootfsDir}"
echo ""

chroot $__RootfsDir apt-get update
chroot $__RootfsDir apt-get -f -y upgrade
chroot $__RootfsDir apt-get -y install $__RPiOSPackages
chroot $__RootfsDir symlinks -cr /usr
chroot $__RootfsDir apt-get clean
