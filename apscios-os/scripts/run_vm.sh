#!/bin/bash
set -e

ISO_FILE="Apscios-Workstation-Live.iso"

if [ ! -f "$ISO_FILE" ]; then
    echo "Error: $ISO_FILE not found. Run build_iso.sh first."
    exit 1
fi

echo "Starting Apscios in QEMU..."
echo "Press Ctrl+Alt+G to release mouse capture."

qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -cdrom "$ISO_FILE" \
    -boot d \
    -vga virtio \
    -display default,show-cursor=on \
    -usb \
    -device usb-tablet
