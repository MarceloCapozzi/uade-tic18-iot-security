#!/bin/bash

# ==============================================================================
# This script is used to set up the CIS benchmark on a Debian-based system.
# It first installs the necessary tools and checks if they are already installed.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Create the directory and clone the repository
sudo mkdir -p /opt/cis-benchmarks

# Change the owner of the directory to the current user
sudo chown -R $USER:docker /opt/cis-benchmarks

# Clone the CIS benchmarks repository
git clone https://github.com/MarceloCapozzi/cis-benchmarks.git /opt/cis-benchmarks
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone the CIS benchmarks repository."
    exit 1
fi

# Check if the tools are installed
if [ ! -d "/opt/cis-benchmarks" ]; then
    echo "Error: Failed to install the CIS benchmarks."
    exit 1
fi

# Completion message
echo "CIS benchmarks have been successfully installed."