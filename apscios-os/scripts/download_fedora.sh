#!/bin/bash
set -e

ISO_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/41/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-41-1.4.iso"
OUTPUT_FILE="Fedora-Workstation-Live-x86_64-41-1.4.iso"

echo "Downloading Fedora 41 Workstation..."
wget -O "$OUTPUT_FILE" "$ISO_URL"

echo "Download complete: $OUTPUT_FILE"
