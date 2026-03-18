# Tycho Syntactic Desktop

Tycho Syntactic Desktop is a desktop application for syntactic analysis, part of the Tycho Brahe Platform.

## Download

Pre-built installers are available on the [**Releases**](https://github.com/tycho-brahe-platform/tycho-desktop/releases) page.

1. Go to [Releases](https://github.com/tycho-brahe-platform/tycho-desktop/releases)
2. Open the latest release (e.g. `v1.0.0`)
3. In the **Assets** section, download the file for your system:

| Platform                  | File to download                                                                                                                                          |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Windows (x64)**         | [tycho-syntactic-setup-1.0.0-x64.exe](https://github.com/tycho-brahe-platform/tycho-desktop/releases/download/v1.0.0/tycho-syntactic-x64-1.0.0.exe)       |
| **Windows (x86)**         | [tycho-syntactic-setup-1.0.0-x86.exe](https://github.com/tycho-brahe-platform/tycho-desktop/releases/download/v1.0.0/tycho-syntactic-x86-1.0.0.exe)       |
| **macOS (Apple Silicon)** | [Tycho Syntactic Desktop-1.0.0-arm64.dmg](https://github.com/tycho-brahe-platform/tycho-desktop/releases/download/v1.0.0/tycho-syntactic-arm64-1.0.0.dmg) |
| **macOS (Intel)**         | [Tycho Syntactic Desktop-1.0.0-x64.dmg](https://github.com/tycho-brahe-platform/tycho-desktop/releases/download/v1.0.0/tycho-syntactic-amd64-1.0.0.dmg)   |
| **Linux**                 | [Tycho Syntactic Desktop-1.0.0-x86_64.AppImage](https://github.com/tycho-brahe-platform/tycho-desktop/releases/download/v1.0.0/tycho-syntactic-1.0.0.exe) |

> **Note:** The links above point to `v1.0.0`. For the latest version, go to [Releases](https://github.com/tycho-brahe-platform/tycho-desktop/releases) and use the download links in the Assets section of the newest release.

## Installation

- **Windows:** Run the `.exe` installer and follow the setup wizard.
- **macOS:** Open the `.dmg` file and drag the app to your Applications folder.
- **Linux:** Make the AppImage executable (`chmod +x *.AppImage`), then run it.

## Quick Start

Follow these steps to get started with syntactic analysis: create a parser, create a corpus, and import your files.

### Step 1: Create a parser

1. Download a parser package from the [Releases](https://github.com/tycho-brahe-platform/tycho-desktop/releases) page (e.g. `parser-parsport.tar.gz`, `parser-synoi.tar.gz`) in the **Assets** section.
2. Extract the downloaded archive to a folder on your computer.
3. Open Tycho Syntactic Desktop and go to **Parsers** (apps menu → Parsers).
4. Click the **Create** button.
5. Enter a name for your parser (e.g. "Parsport").
6. Click **Browse** and select the folder where you extracted the parser files.
7. Confirm to create the parser.

### Step 2: Create a corpus

1. Go to **Corpora** (apps menu → Corpora, or the Home screen).
2. Click the **Create** button.
3. Enter a name for your corpus (e.g. "My Corpus").
4. Click **Browse** and select a folder that will serve as the corpus upload directory (this is where imported documents will be stored).
5. Confirm to create the corpus.

### Step 3: Import files from a folder

1. On the Corpora screen, click on the corpus card you created to open its catalog.
2. Click the **Settings** button (top right).
3. In the left menu, select **Files Import**.
4. Choose the file type to import:
   - **PSD files** — for plain text or PSD-format files (`.psd`, `.txt`)
   - **JSON files** — for Tycho JSON format files (`.json`)
5. Click **Browse** and select the folder containing the files you want to import.
6. Confirm to start the import. The app will process all matching files in the folder and add them as documents to your corpus.

Once the import completes, you can open documents from the catalog, run syntactic parsing with your parser, and use the Search tool to query your corpus.

## License

See the repository for license information.
