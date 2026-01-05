#!/bin/bash
set -e

# Apscios OS Environment Setup Script
# This script prepares the local host environment by installing necessary dependencies
# for building and running the Apscios OS ISO.

echo "Checking system compatibility..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    DISTRO=$ID
else
    echo "Error: Cannot detect OS. Please install dependencies manually."
    exit 1
fi

echo "Detected OS: $OS ($DISTRO)"

install_deps_debian() {
    echo "Updating package lists..."
    sudo apt-get update
    echo "Installing dependencies: xorriso, syslinux, syslinux-utils, qemu-system-x86, genisoimage..."
    sudo apt-get install -y xorriso syslinux syslinux-utils qemu-system-x86 genisoimage
}

install_deps_fedora() {
    echo "Installing dependencies: xorriso, syslinux, qemu-kvm..."
    sudo dnf install -y xorriso syslinux qemu-kvm
}

case "$DISTRO" in
    ubuntu|debian|linuxmint)
        install_deps_debian
        ;;
    fedora|rhel|centos)
        install_deps_fedora
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        echo "Please manually install: xorriso, syslinux, qemu-kvm (or qemu-system-x86)"
        exit 1
        ;;
esac

echo "Environment setup complete!"
echo "You can now run ./scripts/download_fedora.sh and ./scripts/build_iso.sh"
