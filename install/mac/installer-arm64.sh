#!/bin/bash
export DOCKER_PLATFORM="linux/arm64"

echo "Welcome to the Tycho Desktop Installer for macOS"

# Step 1: Ask for the root folder to install
read -p "Please enter the root folder for installation (e.g., /Users/yourname/tycho): " ROOT_FOLDER

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
#sed -i '' 's/\r$//' "$ROOT_FOLDER/backup/"*.sh
chmod +x "$ROOT_FOLDER/backup/"*.sh

# Step 6: Export the input to DEFAULT_ROOT_FOLDER environment variable
export DEFAULT_ROOT_FOLDER="$ROOT_FOLDER"

# Path to the .env file (adjust this if the .env is in a different location)
ENV_FILE="$ROOT_FOLDER/.env"

# Check if the .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo ".env file not found at $ENV_FILE"
  exit 1
fi

# Update or add DEFAULT_ROOT_FOLDER in .env
if grep -q "^DEFAULT_ROOT_FOLDER=" "$ENV_FILE"; then
  sed -i.bak "s|^DEFAULT_ROOT_FOLDER=.*|DEFAULT_ROOT_FOLDER=${ROOT_FOLDER}|" "$ENV_FILE"
else
  sed -i.bak "1s|^|DEFAULT_ROOT_FOLDER=${ROOT_FOLDER}\n|" "$ENV_FILE"
fi

# Update or add BACKUP_SCRIPT_TYPE in .env
if grep -q "^BACKUP_SCRIPT_TYPE=" "$ENV_FILE"; then
  sed -i.bak "s|^BACKUP_SCRIPT_TYPE=.*|BACKUP_SCRIPT_TYPE=sh|" "$ENV_FILE"
else
  sed -i.bak "1s|^|BACKUP_SCRIPT_TYPE=sh\n|" "$ENV_FILE"
fi

echo "DEFAULT_ROOT_FOLDER set to ${ROOT_FOLDER} in $ENV_FILE"

# Step 7: Execute Docker Compose file: docker-compose.yml
echo "Executing docker-compose.yml..."
docker-compose pull
docker-compose -f "$ROOT_FOLDER/docker-compose.yml" up -d

echo "Waiting while services start..."
for i in {15..1}; do
  sleep 1
done

# Step 8: Open Chrome to sign up
echo "Opening Chrome to sign up"
open -a "Google Chrome" "http://local.tychoplatform.com/auth/signup"

echo "Installation completed successfully."