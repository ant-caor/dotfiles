#!/bin/bash

set -x

sudo rm -Rf /Applications/Docker.app
sudo rm -f /usr/local/bin/docker
sudo rm -f /usr/local/bin/docker-machine
sudo rm -f /usr/local/bin/com.docker.cli
sudo rm -f /usr/local/bin/docker-compose
sudo rm -f /usr/local/bin/docker-compose-v1
sudo rm -f /usr/local/bin/docker-credential-desktop
sudo rm -f /usr/local/bin/docker-credential-ecr-login
sudo rm -f /usr/local/bin/docker-credential-osxkeychain
sudo rm -f /usr/local/bin/hub-tool
sudo rm -f /usr/local/bin/hyperkit
sudo rm -f /usr/local/bin/kubectl.docker
sudo rm -f /usr/local/bin/vpnkit
sudo rm -Rf ~/.docker
sudo rm -Rf ~/Library/Containers/com.docker.docker
sudo rm -Rf ~/Library/Application\ Support/Docker\ Desktop
sudo rm -Rf ~/Library/Group\ Containers/group.com.docker
sudo rm -f ~/Library/HTTPStorages/com.docker.docker.binarycookies
sudo rm -f /Library/PrivilegedHelperTools/com.docker.vmnetd
sudo rm -f /Library/LaunchDaemons/com.docker.vmnetd.plist
sudo rm -Rf ~/Library/Logs/Docker\ Desktop
sudo rm -Rf /usr/local/lib/docker
sudo rm -f ~/Library/Preferences/com.docker.docker.plist
sudo rm -Rf ~/Library/Saved\ Application\ State/com.electron.docker-frontend.savedState
sudo rm -f ~/Library/Preferences/com.electron.docker-frontend.plist

sudo rm -rf ~/Library/Group\ Containers/group.com.docker/pki/
sudo rm -rf ~/.kube

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Run commands with elevated privileges without asking for password again
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &

echo "Starting Docker uninstallation..."

# Stop Docker if it's running
if command_exists docker; then
    echo "Stopping Docker..."
    osascript -e 'quit app "Docker"'
    sleep 5
else
    echo "Docker is not running or installed."
fi

# Remove Docker app from Applications
echo "Removing Docker app from /Applications..."
sudo rm -rf /Applications/Docker.app

# Download and install Docker for Apple Silicon
echo "Downloading Docker for Apple Silicon..."
curl -L -o ~/Downloads/Docker.dmg https://desktop.docker.com/mac/main/arm64/Docker.dmg

echo "Installing Docker..."
hdiutil attach ~/Downloads/Docker.dmg
sudo cp -R /Volumes/Docker/Docker.app /Applications
hdiutil detach /Volumes/Docker
rm ~/Downloads/Docker.dmg

# Start Docker
echo "Starting Docker Desktop..."
open -a Docker

echo "Docker installation completed. Please open Docker and check manually."
