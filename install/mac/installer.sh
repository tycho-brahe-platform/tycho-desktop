#!/bin/bash

echo "Welcome to the Tycho Desktop Installer for macOS"

# Step 1: Ask for the root folder to install
read -p "Please enter the root folder for installation (e.g., /Users/yourname/tycho): " ROOT_FOLDER

# Export the input to DEFAULT_ROOT_FOLDER environment variable
export DEFAULT_ROOT_FOLDER="$ROOT_FOLDER"

# Step 2: Download compacted file from Github
echo "Downloading the Tycho Desktop package..."
curl -L -o tycho-desktop.zip https://github.com/tycho-brahe-platform/tycho-desktop/raw/main/install/tycho-desktop.zip

# Step 3: Extract files to the root folder
echo "Extracting files..."
mkdir -p "$ROOT_FOLDER"
unzip tycho-desktop.zip -d "$ROOT_FOLDER"

# Step 4: Create subfolders
echo "Creating subfolders..."
mkdir -p "$ROOT_FOLDER/httpd" "$ROOT_FOLDER/httpd/upload" "$ROOT_FOLDER/httpd/parser" "$ROOT_FOLDER/backup"

# Step 5: Copy shell scripts from 'scripts' folder to 'ROOT_FOLDER/backup'
echo "Copying shell scripts..."
cp -R "$ROOT_FOLDER/scripts/"* "$ROOT_FOLDER/backup"

# Step 6: Execute Docker Compose file: docker-compose.yml
echo "Executing docker-compose.yml..."
docker-compose -f "$ROOT_FOLDER/docker-compose.yml" up -d

# Step 7: Open Chrome at http://local.tychoplatform.com/auth
echo "Opening Chrome to http://local.tychoplatform.com/auth"
open -a "Google Chrome" "http://local.tychoplatform.com/auth"

echo "Installation completed successfully."