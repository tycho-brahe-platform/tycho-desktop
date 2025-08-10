# Tycho Brahe Platform Desktop for Syntactic Revision

The Tycho Brahe Platform has a beta desktop version initially launched for **macOS**.

It has fewer features than the full server version and is available **only for syntactic revision**; i.e., editing and transcription are **not** available, but documents may be imported.

## Installation

### macOS

1. Add the local server address to your hosts file:

   ```bash
   echo "127.0.0.1 local.tychoplatform.com" | sudo tee -a /etc/hosts
   ```

2. Download the ARM64 installer script from the following URL:

   [https://github.com/tycho-brahe-platform/tycho-desktop/blob/main/install/mac/installer-arm64.sh](https://github.com/tycho-brahe-platform/tycho-desktop/blob/main/install/mac/installer-arm64.sh)

3. Make the downloaded installer executable:

   ```bash
   chmod +x installer-arm64.sh
   ```

4. Run the installer:

   ```bash
   ./installer-arm64.sh
   ```

5. When prompted, enter the default folder for installation as requested.
