# Apscios OS (Fedora Rebrand)

This project contains scripts to download, rebrand, and test a custom ISO based on Fedora Workstation.

## Prerequisites

*   Linux environment (Fedora/Ubuntu/Debian)
*   Root privileges (for mounting/chrooting)
*   Tools: `wget`, `xorriso`, `squashfs-tools` (unsquashfs/mksquashfs), `qemu-system-x86` (for testing), `python3` (for serving)

## Usage

1.  **Download the Base ISO**
    ```bash
    ./scripts/download_fedora.sh
    ```

2.  **Build the Custom ISO**
    ```bash
    # This requires xorriso and potentially root privileges depending on your setup
    ./scripts/build_iso.sh
    ```
    This will create `Apscios-Workstation-Live.iso`.

3.  **Test in VM**
    ```bash
    ./scripts/run_vm.sh
    ```

4.  **Host the ISO**
    ```bash
    python3 scripts/server.py
    ```
    Access at `http://localhost:8000`.

## Project Structure

*   `scripts/`: Automation scripts.
*   `index.html`: Download page for the server.
