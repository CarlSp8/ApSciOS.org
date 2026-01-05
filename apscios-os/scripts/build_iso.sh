#!/bin/bash
set -e

# Configuration
SOURCE_ISO="Fedora-Workstation-Live-x86_64-41-1.4.iso"
WORK_DIR="work_dir"
NEW_ISO="Apscios-Workstation-Live.iso"
NEW_LABEL="Apscios-41"

# Check for required tools
for tool in xorriso; do
    if ! command -v $tool &> /dev/null; then
        echo "Error: $tool is not installed."
        exit 1
    fi
done

if [ ! -f "$SOURCE_ISO" ]; then
    echo "Error: Source ISO $SOURCE_ISO not found. Run download_fedora.sh first."
    exit 1
fi

echo "Cleaning up previous work..."
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

echo "Extracting ISO..."
xorriso -osirrox on -indev "$SOURCE_ISO" -extract / "$WORK_DIR"

echo "Rebranding to Apscios..."

# 1. Modify GRUB configuration
# Search for 'Fedora' and replace with 'Apscios' in typical locations
find "$WORK_DIR" -name "grub.cfg" -exec sed -i 's/Fedora/Apscios/g' {} +
find "$WORK_DIR" -name "isolinux.cfg" -exec sed -i 's/Fedora/Apscios/g' {} +

# 2. Rename EFI boot label if possible (requires binary edit or simpler just config change)
# We stick to config changes for safety.

echo "Repacking ISO..."
# Note: Modern Fedora ISOs use specific xorriso flags for EFI support.
# We attempt to replicate a hybrid ISO structure.

# Locate isohdpfx.bin
MBR_TEMPLATE=""
for path in /usr/lib/ISOLINUX/isohdpfx.bin /usr/share/syslinux/isohdpfx.bin; do
    if [ -f "$path" ]; then
        MBR_TEMPLATE="$path"
        break
    fi
done

if [ -z "$MBR_TEMPLATE" ]; then
    echo "Error: isohdpfx.bin not found in common locations. Please install syslinux or isolinux."
    exit 1
fi

xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "$NEW_LABEL" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -isohybrid-mbr "$MBR_TEMPLATE" \
    -eltorito-alt-boot \
    -e images/efiboot.img \
    -no-emul-boot -isohybrid-gpt-basdat \
    -output "$NEW_ISO" \
    "$WORK_DIR"

echo "Done! Created $NEW_ISO"
