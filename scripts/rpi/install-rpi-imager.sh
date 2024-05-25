#!/bin/bash

# ==============================================================================
# This script is used to install the Raspberry Pi Imager tool on a Raspberry Pi OS system.
# It first updates the package list and then installs the Raspberry Pi Imager tool.
# If the installation is successful, it prints a completion message.
# If any errors occur during the process, it logs the error and exits with an error code.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Update the package list
sudo apt-get update

# Install the Raspberry Pi Imager tool
sudo apt-get -y install rpi-imager

# Check if there was an error during the installation
if [ $? -ne 0 ]; then
    echo "Error: a problem was detected during the installation process."
    exit 1
fi

# Completion message
echo "Process completed successfully."