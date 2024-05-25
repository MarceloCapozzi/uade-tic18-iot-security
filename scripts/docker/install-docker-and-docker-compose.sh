#!/bin/bash

# ==============================================================================
# This script is used to install and configure Docker and Docker Compose on a Raspberry Pi OS system.
# It first checks if Docker is already installed. If not, it removes any existing versions, installs the prerequisites, and then installs Docker.
# It then checks if Docker Compose is already installed. If not, it installs Docker Compose and changes permissions for non-root users.
# Finally, it displays the installed versions of Docker and Docker Compose and prints a completion message.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Install and configure Docker and Docker Compose
# Check if Docker is already installed
if ! command -v docker &> /dev/null; then
    # Remove existing versions
    sudo apt-get remove docker docker-engine docker.io containerd runc

    # Install and configure prerequisites
    sudo apt-get update
    sudo apt-get -y install ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt-get update
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Check installation result
    if [ $? -ne 0 ]; then
        echo "Error: Installing Docker."
        exit 1
    fi
fi

# Install Docker Compose
# Check if Docker Compose is already installed
if ! command -v docker-compose &> /dev/null; then
    # Install Docker Compose
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-armv7 -o /usr/local/bin/docker-compose

    # Check installation result
    if [ $? -ne 0 ]; then
        echo "Error: Installing Docker Compose."
        exit 1
    fi

    # Change permissions for non-root users
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
fi

# Show installed versions for Docker and Docker Compose
docker --version
docker-compose --version

# Completion message
echo "Installation and configuration process completed."