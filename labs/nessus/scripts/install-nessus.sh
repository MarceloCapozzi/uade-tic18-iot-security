#!/bin/bash

# ==============================================================================
# This script is used to install the Nessus vulnerability scanner on a system.
# It first determines the system architecture and then downloads the appropriate Nessus package.
# After downloading, it installs the package and checks the installation result.
# If the installation is successful, it prints a completion message.
# If any errors occur during the process, it logs the error and exits with an error code.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Get the system architecture
arch=$(dpkg --print-architecture)

# Nessus package paths and URLs
nessus_path="/opt/tools/nessus"
nessus_pkg_url_armhf="https://github.com/MarceloCapozzi/tf22-iot-security/raw/main/tools/nessus/nessus-10.4.1-raspberrypios_armhf.deb"
nessus_pkg_url_amd64="https://github.com/MarceloCapozzi/tf22-iot-security/raw/main/tools/nessus/nessus-10.4.1-ubuntu1404_amd64.deb"
nessus_pkg="nessus-10.4.1.deb"

# Check if Nessus is already installed
if dpkg -l | grep -q nessus; then
    echo "Nessus is already installed."
    exit 0
fi

# Validate dependencies
if ! command -v dpkg &> /dev/null; then
    echo "Error: dpkg is not installed. Please install it before running this script."
    exit 1
fi

# Evaluate the system architecture to determine the package URL
case $arch in
    amd64)
        nessus_url_pkg=$nessus_pkg_url_amd64 ;;
    armhf)
        nessus_url_pkg=$nessus_pkg_url_armhf ;;
    *)
        echo "No installer available for architecture: $arch."
        exit 1 ;;
esac

# Create directory for the installer
sudo mkdir -p $nessus_path

# Download the installer
sudo wget -q $nessus_url_pkg -O $nessus_path/$nessus_pkg

# Install the application
sudo dpkg -i $nessus_path/$nessus_pkg

# Check installation result
if [ $? -ne 0 ]; then
    echo "Error: Failed to install the application (arch:$arch-app:$nessus_pkg)"
    exit 1
fi

# Completion message
echo "Nessus is installed."