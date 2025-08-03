# tycho-desktop

Tycho Brahe Platform Desktop Installation

Tasks:

1- Ask for the root folder to install
2- Download compacted file from Github at address: https://github.com/tycho-brahe-platform/tycho-desktop/install/mac/tycho-desktop.tar
3- Extract files to the root folder
4- Create the following subfolders: ROOT_FOLDER/httpd, ROOT_FOLDER/httpd/upload, ROOT_FOLDER/httpd/parser, ROOT_FOLDER/backup
5- Copy the shell scripts from scripts folder to ROOT_FOLDER/backup
6- Execute the Docker Compose file: docker-compose-infra.yml
7- Execute the Docker Compose file: docker-compose-basic.yml
8- Open Chrome to http://local.tychoplatform.com/auth

chmod + x installaer
sudo add http://local.tychoplatform.com to /etc/hosts
