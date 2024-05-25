#!/bin/bash

# ==============================================================================
# This script is used to install Hydra on a Debian-based system.
# It first checks if the build-essential package is installed.
# If not, it installs the build-essential package.
# It then checks if git is installed and clones the Hydra repository.
# The script configures, builds, and installs Hydra.
# Finally, it installs additional dependencies for running on Ubuntu environments and creates a shortcut.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Set the package name
package="build-essential"

# Check if the package is installed
if command -v "$package" >/dev/null 2>&1; then
    echo "The $package package is already installed."
else
    echo "The $package package is not installed. Installing..."
    # Update the package list before installing the package
    sudo apt-get update
    # Install the package
    sudo apt-get install -y "$package"
    # Check if the installation was successful
    if command -v "$package" >/dev/null 2>&1; then
        echo "The $package package has been installed successfully."
    else
        echo "Error: Failed to install the $package package."
    fi
fi

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Git is not installed. Please install it manually."
    exit 1
fi

# Clone the Hydra repository
git clone https://github.com/vanhauser-thc/thc-hydra && cd thc-hydra

# Application configuration
sudo ./configure 
sudo make -j$(nproc)
sudo make install

# Install additional dependencies for running on Ubuntu environments
sudo apt-get -y install libssl-dev libssh-dev libpcre3-dev libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-dev firebird-dev libmemcached-dev libgpg-error-dev libgcrypt20-dev

# Check if the installation last command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to install additional dependencies."
    exit 1
fi

# Create a shortcut
sudo ln -t /usr/bin -s /usr/local/bin/hydra

# Check if the installation was successful
if command -v hydra >/dev/null 2>&1; then
    echo "Hydra has been installed successfully."
else
    echo "Error: Failed to install Hydra."
fi