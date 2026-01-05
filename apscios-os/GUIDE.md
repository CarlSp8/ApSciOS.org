# Apscios OS - Production Guide

This guide explains how to generate the Apscios OS ISO, a custom remaster of Fedora Workstation, and run it on your local machine.

## 1. Environment Setup (Local Host)

Before you begin, you must set up your local environment. We have provided a script to automate this for Debian/Ubuntu and Fedora systems.

```bash
# Run from the repository root
./scripts/setup_env.sh
```

This will install:
*   `xorriso`: For ISO manipulation.
*   `syslinux`: For bootloader files (`isohdpfx.bin`).
*   `qemu`: For testing the ISO in a virtual machine.

## 2. GitHub Actions (Cloud Build)

You can also build the ISO automatically using GitHub Actions.

1.  Push this repository to GitHub.
2.  Navigate to the **Actions** tab.
3.  Select the **Build Apscios OS** workflow.
4.  The build will run automatically on push, or you can trigger it manually.
5.  Once complete, download the `Apscios-Workstation-Live` artifact from the run summary.

## 2. Download Base Image

Download the official Fedora Workstation Live ISO.

```bash
./scripts/download_fedora.sh
```
This script fetches the ISO from the official Fedora mirrors and verifies its integrity.

## 3. Build Apscios ISO (The "Real Core")

Run the build script to unpack, modify, and repack the ISO. This is the core "factory" script.

```bash
./scripts/build_iso.sh
```

**What this script does:**
1.  **Extracts** the Fedora ISO filesystem.
2.  **Rebrands** the bootloader configuration (GRUB/Isolinux) to "Apscios".
3.  **Repacks** the ISO using `xorriso` with hybrid boot support (EFI + Legacy BIOS).

*Output:* `Apscios-Workstation-Live.iso`

## 4. Test in Virtual Machine

To verify the ISO works without burning it to a USB drive, use the included VM script.

```bash
./scripts/run_vm.sh
```

This command launches a QEMU virtual machine with:
*   KVM acceleration (for near-native speed).
*   4GB RAM.
*   VirtIO graphics.

## 5. Host and Distribute

To share your build on your local network:

```bash
python3 scripts/server.py
```

Navigate to `http://localhost:8000` to see the download page.
