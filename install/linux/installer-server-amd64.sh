#!/bin/bash
set -e

export DOCKER_PLATFORM="linux/amd64"
TYCHO_SERVER_ADDRESS=http://local.tychoplatform.com
PROFILE=develop

echo "🚀 Welcome to the Tycho Server Installer for Linux"

# Default folder suggestion
DEFAULT_FOLDER="/data/tycho"

# Step 1: Ask for the root folder to install (with default)
read -p "Please enter the root folder for installation [$DEFAULT_FOLDER]: " ROOT_FOLDER

# If user presses Enter, use the default
ROOT_FOLDER=${ROOT_FOLDER:-$DEFAULT_FOLDER}

echo "✅ Installation folder set to: $ROOT_FOLDER"

# Step 2: Download compacted file from Github
echo "📦 Downloading the Tycho Server package..."
curl -L -o tycho-server.zip https://github.com/tycho-brahe-platform/tycho-desktop/raw/main/install/tycho-server.zip

# Step 3: Extract files to the root folder
echo "📂 Extracting files..."
mkdir -p "$ROOT_FOLDER"
unzip -q tycho-server.zip -d "$ROOT_FOLDER"

# Step 4: Create subfolders
echo "📁 Creating subfolders..."
mkdir -p "$ROOT_FOLDER/httpd" "$ROOT_FOLDER/httpd/upload" "$ROOT_FOLDER/httpd/parser" "$ROOT_FOLDER/backup"

# Step 5: Copy shell scripts from 'scripts' folder to 'ROOT_FOLDER/backup'
echo "🔧 Copying shell scripts..."
cp -R "$ROOT_FOLDER/scripts/"* "$ROOT_FOLDER/backup"
chmod +x "$ROOT_FOLDER/backup/"*.sh

# Step 6: Export the input to DEFAULT_ROOT_FOLDER
export DEFAULT_ROOT_FOLDER="$ROOT_FOLDER"

# Update .env
echo "PROFILE=${PROFILE}" >> "$ROOT_FOLDER/.env"
ENV_FILE="$ROOT_FOLDER/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env file not found at $ENV_FILE"
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
echo "✅ Environment variables updated in $ENV_FILE"

# Step 7: Start core infrastructure (no gateway or apps yet)
echo "🐳 Starting infrastructure containers (Eureka, ConfigServer, Mongo, etc)..."
docker-compose -f "$ROOT_FOLDER/docker-compose.yml" pull
docker-compose -f "$ROOT_FOLDER/docker-compose.yml" up -d

# Wait for Eureka
echo "⏳ Waiting for Eureka to be healthy..."
until curl -sf ${TYCHO_SERVER_ADDRESS}/eureka/actuator/health | grep '"status":"UP"' > /dev/null; do sleep 5; done
echo "✅ Eureka is UP."

# Wait for Config Server
echo "⏳ Waiting for Config Server to be healthy..."
until curl -sf ${TYCHO_SERVER_ADDRESS}/configserver/tycho-gateway/default | grep 'application' > /dev/null; do sleep 5; done
echo "✅ Config Server is ready to serve configs."

# Step 8: Start ELK
echo "🐳 Starting ELK containers (Elasticsearch, Logstash, Kibana)..."
docker-compose -f "$ROOT_FOLDER/docker-compose.elk.yml" pull
docker-compose -f "$ROOT_FOLDER/docker-compose.elk.yml" up -d

# Step 9: Start Gateway (after config server is ready)
echo "🚪 Starting Gateway container..."
docker-compose -f "$ROOT_FOLDER/docker-compose.gateway.yml" pull
docker-compose -f "$ROOT_FOLDER/docker-compose.gateway.yml" up -d

# Wait for Gateway
echo "⏳ Waiting for Gateway to be healthy..."
until curl -sf ${TYCHO_SERVER_ADDRESS}/gateway/actuator/health | grep '"status":"UP"' > /dev/null; do sleep 5; done
echo "✅ Gateway is UP."

# Step 10: Start application containers
echo "🚀 Starting application containers..."
docker-compose -f "$ROOT_FOLDER/docker-compose.apps.yml" pull
docker-compose -f "$ROOT_FOLDER/docker-compose.apps.yml" up -d

# Step 11: Start editor containers
echo "🚀 Starting editor containers..."
docker-compose -f "$ROOT_FOLDER/docker-compose.editor.yml" pull
docker-compose -f "$ROOT_FOLDER/docker-compose.editor.yml" up -d

# Step 12: Check application health
sleep_seconds=5
max_retries=30
apps=(auth functions admin catalog parser/engine parser revision search io edictor sentence translation transcriber viewer)

check_app() {
  local app=$1
  local retries=0
  local printed_waiting_msg=0

  while [ $retries -lt $max_retries ]; do
    status=$(curl -s "${TYCHO_SERVER_ADDRESS}/api/${app}/actuator/health" | grep -o '"status":"UP"')
    if [[ "$status" == '"status":"UP"' ]]; then
      echo -e "\n✅ App $app is UP"
      return 0
    else
      if [ $printed_waiting_msg -eq 0 ]; then
        echo -n "⏳ Waiting for $app"
        printed_waiting_msg=1
      else
        echo -n "."
      fi
      sleep $sleep_seconds
      ((retries++))
    fi
  done

  echo -e "\n❌ App $app failed to start in time."
  return 1
}

echo "🔍 Checking application status..."
all_ok=true
for app in "${apps[@]}"; do
  check_app "$app" || all_ok=false
done

echo "✅ Installation completed successfully."
exit 0
