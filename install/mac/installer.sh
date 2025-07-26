#!/bin/bash

echo "Welcome to the Tycho Desktop Installer for macOS"

# Step 1: Ask for the root folder to install
read -p "Please enter the root folder for installation (e.g., /Users/yourname/tycho): " ROOT_FOLDER

# Step 2: Download compacted file from Github
echo "Downloading the Tycho Desktop package..."
curl -L https://github.com/tycho-brahe-platform/tycho-desktop/blob/main/install/tycho-desktop.zip

# Step 3: Extract files to the root folder
echo "Extracting files..."
mkdir -p "$ROOT_FOLDER"
unzip tycho-desktop.zip -d "$ROOT_FOLDER"

# Step 4: Create subfolders
echo "Creating subfolders..."
mkdir -p "$ROOT_FOLDER/httpd" "$ROOT_FOLDER/httpd/upload" "$ROOT_FOLDER/httpd/parser" "$ROOT_FOLDER/backup"

# Step 5: Copy shell scripts from 'scripts' folder to 'ROOT_FOLDER/backup'
echo "Copying shell scripts..."
cp -R "scripts/"* "$ROOT_FOLDER/backup"

# Step 6: Execute Docker Compose file: docker-compose-infra.yml
echo "Executing docker-compose-infra.yml..."
docker-compose -f "$ROOT_FOLDER/docker-compose-infra.yml" up -d

# Step 7: Execute Docker Compose file: docker-compose-basic.yml
echo "Executing docker-compose-basic.yml..."
docker-compose -f "$ROOT_FOLDER/docker-compose-basic.yml" up -d

# Step 8: Open Chrome at http://local.tychoplatform.com/auth
echo "Opening Chrome to http://local.tychoplatform.com/auth"
open -a "Google Chrome" "http://local.tychoplatform.com/auth"

echo "Installation completed successfully."