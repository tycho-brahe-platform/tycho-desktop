@echo off
setlocal EnableDelayedExpansion

echo Welcome to the Tycho Desktop Installer for Windows

REM Step 1: Ask for the root folder to install
set /p ROOT_FOLDER=Please enter the root folder for installation (e.g., C:\tycho): 

REM Step 1.1: Ask for 7-Zip location
set DEFAULT_7ZIP="C:\Program Files\7-Zip\7z.exe"
set /p ZIP_EXE=Please enter the full path to 7-Zip (default: !DEFAULT_7ZIP!): 
if "!ZIP_EXE!"=="" set ZIP_EXE=!DEFAULT_7ZIP!

if not exist !ZIP_EXE! (
    echo ERROR: 7-Zip not found at !ZIP_EXE!
    echo Please install 7-Zip from https://www.7-zip.org/ and run the installer again.
    pause
    exit /b 1
)

REM Step 2: Download compacted file from Github
echo Downloading the Tycho Desktop package...
curl -L -o tycho-desktop.zip https://github.com/tycho-brahe-platform/tycho-desktop/raw/install/windows/tycho-desktop.zip

if not exist tycho-desktop.zip (
    echo ERROR: Failed to download the zip file.
    pause
    exit /b 1
)

REM Step 3: Extract files to the root folder
echo Extracting files...
mkdir "%ROOT_FOLDER%"
"%ZIP_EXE%" x tycho-desktop.zip -o"%ROOT_FOLDER%" -y

REM Step 4: Create subfolders
echo Creating subfolders...
mkdir "%ROOT_FOLDER%\httpd"
mkdir "%ROOT_FOLDER%\httpd\upload"
mkdir "%ROOT_FOLDER%\httpd\parser"
mkdir "%ROOT_FOLDER%\backup"

REM Step 5: Copy shell scripts from 'scripts' folder to 'ROOT_FOLDER\backup'
echo Copying shell scripts...
xcopy /E /I /Y "scripts\*" "%ROOT_FOLDER%\backup\"

REM Step 6: Execute Docker Compose file: docker-compose-infra.yml
echo Executing docker-compose-infra.yml...
docker-compose -f "%ROOT_FOLDER%\docker-compose-infra.yml" up -d

REM Step 7: Execute Docker Compose file: docker-compose-basic.yml
echo Executing docker-compose-basic.yml...
docker-compose -f "%ROOT_FOLDER%\docker-compose-basic.yml" up -d

REM Step 8: Open Chrome at http://local.tychoplatform.com/auth
echo Opening Chrome to http://local.tychoplatform.com/auth
start chrome "http://local.tychoplatform.com/auth"

echo Installation completed successfully.
pause
