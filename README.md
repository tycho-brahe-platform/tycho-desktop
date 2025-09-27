# Tycho Brahe Platform Desktop for Syntactic Revision

The Tycho Brahe Platform has a beta desktop version initially launched for **macOS**.

It has fewer features than the full server version and is available **only for syntactic revision**; i.e., editing and transcription are **not** available, but documents may be imported.

## Installation

### macOS

1. Before starting the installation, you must have **Docker Desktop** installed.

- **Apple processors (M1, M2 and newer)**: [Download here](https://desktop.docker.com/mac/main/arm64/Docker.dmg)
- **Intel processors**: [Download here](https://desktop.docker.com/mac/main/amd64/Docker.dmg)
- **macOS Big Sur (v. 11) or earlier**: Install version [4.22.0 for Intel](https://desktop.docker.com/mac/main/amd64/117440/Docker.dmg)

2. Add the local server address to your hosts file:

   ```bash
   echo "127.0.0.1 local.tychoplatform.com" | sudo tee -a /etc/hosts
   ```

3. Download the ARM64 installer script from the following URL:

   [https://github.com/tycho-brahe-platform/tycho-desktop/blob/main/install/mac/installer-arm64.sh](https://github.com/tycho-brahe-platform/tycho-desktop/blob/main/install/mac/installer-arm64.sh)

4. Make the downloaded installer executable:

   ```bash
   chmod +x installer-arm64.sh
   ```

5. Run the installer:

   ```bash
   ./installer-arm64.sh
   ```

6. When prompted, enter the default folder for installation as requested.
