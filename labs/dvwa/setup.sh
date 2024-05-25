#!/bin/bash

# ==============================================================================
# This script is used to install and configure Docker and Docker Compose on a Raspberry Pi OS system.
# It first checks if Docker is already installed. If not, it removes any existing versions, installs the prerequisites, and then installs Docker.
# It then checks if Docker Compose is already installed. If not, it installs Docker Compose and changes permissions for non-root users.
# Finally, it displays the installed versions of Docker and Docker Compose and prints a completion message.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Enable and start the openssh-server service
sudo systemctl enable ssh
sudo systemctl start ssh

# Check if the service is running
if ! systemctl is-active --quiet ssh; then
    echo "Error: Failed to start the ssh service."
    exit 1
fi

# Install and configure Docker and Docker Compose
# Check if Docker is already installed
if ! command -v docker &> /dev/null; then
    # Install Docker and Docker Compose
    wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/scripts/docker/install-docker-and-docker-compose.sh | bash

    # Check installation result
    if [ $? -ne 0 ]; then
        echo "Error: Installing Docker."
        exit 1
    fi
fi

# Display Docker version
docker_version=$(docker --version)
echo "Docker version: $docker_version"

# Display Docker Compose version
docker_compose_version=$(docker-compose --version)
echo "Docker Compose version: $docker_compose_version"

# Completion message
echo "Docker and Docker Compose have been successfully installed and configured."

# configure dvwa and run the container
# Check if the DVWA container is already running
if [ "$(docker ps -q -f name=dvwa)" ]; then
    echo "DVWA container is already running."
    exit 0
fi

# Configure and run the DVWA container
# Create the directory and download the docker-compose.yml file
mkdir -p /opt/dvwa
# Change to the directory
cd /opt/dvwa

# Download the docker-compose.yml file
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/labs/dvwa/compose/docker-compose.yml > docker-compose.yml

# Start the DVWA container
docker-compose up -d

# Check if the container is running
if [ "$(docker ps -q -f name=dvwa)" ]; then
    echo "DVWA container is running."
else
    echo "Error: Failed to start the DVWA container."
    exit 1
fi

# Configure firewall rules
# Check if the firewall is active
if ! systemctl is-active --quiet iptables; then
    echo "Error: The iptables service is not active."
    exit 1
fi

# Disable the firewall for the host
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/scripts/firewall/disable-iptables.sh | bash

# Check last command result
if [ $? -ne 0 ]; then
    echo "Error: Disabling iptables."
    exit 1
fi

# Completion message
echo "DVWA container is running and firewall rules have been configured."