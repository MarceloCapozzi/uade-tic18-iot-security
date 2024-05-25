#!/bin/bash

# ==============================================================================
# This script is used to set up Nessus and Hydra on a Debian-based system.
# It first installs Nessus and checks if it is already installed.
# It then installs Hydra and checks if it is already installed.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Install Nessus
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/labs/nessus/scripts/install-nessus.sh | bash
# Check if Nessus is not installed
if ! dpkg -l | grep -q nessus; then
    echo "Error: Failed to install Nessus."
    exit 1
fi

# Install Hydra
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/labs/nessus/scripts/install-hydra.sh | bash
# Check if Hydra is not installed
if ! command -v hydra &> /dev/null; then
    echo "Error: Failed to install Hydra."
    exit 1
fi

# Completion message
echo "Nessus and Hydra have been successfully installed."