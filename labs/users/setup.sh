#!/bin/bash

# ==============================================================================
# This script is used to set up the startup script and new user script on a Raspberry Pi OS system.
# It first downloads the scripts and sets the execute permissions.
# It then appends the command to execute the startup script to the /etc/profile file.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Variables for the temporary partitions
tools=/tmp/rootfs/opt/tools

# Download and execute the script to mount partition to folder
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/labs/users/scripts/mount-partition-to-folder.sh | bash

# Create the tools directory if it doesn't exist
sudo mkdir -p $tools

# Download the startup.sh and new-user.sh scripts
sudo wget -q -O $tools/startup.sh https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/labs/users/scripts/startup.sh
sudo wget -q -O $tools/new-user.sh https://raw.githubusercontent.com/MarceloCapozzi/uade-tic18-iot-security/main/labs/users/scripts/new-user.sh

# Set execute permissions for the scripts
sudo chmod +x $tools/{new-user.sh,startup.sh}

# Append the command to execute startup.sh to /etc/profile
sudo su -c "echo 'bash /opt/tools/startup.sh' >> /tmp/rootfs/etc/profile"

# Unmount the temporary partitions
sudo umount /tmp/{boot,rootfs}