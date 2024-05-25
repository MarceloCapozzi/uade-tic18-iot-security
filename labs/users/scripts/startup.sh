#!/bin/bash

# ==============================================================================
# This script is used to create a new user or change the password of an existing user in the file system of a Raspberry Pi OS system.
# It first checks if the device exists, then creates a user with a specific password.
# If the user already exists, it changes the password of the existing user.
# If the device is not found, it displays an error message.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Request user input for the username and password.
# The script will create a new user or change the password of an existing user.
# The username and password must meet the following requirements:

# User name - Minimum number of characters: 4.
read -p "Enter username (minimum 4 characters): " username

# Password for the user (USERNAME) - Minimum number of characters: 6.
read -p "Enter password (minimum 6 characters): " password

# Variables for the iterative loop.
try=1 # Counter for iterative loop.
max_try=120 # Maximum number of attempts.
timeout=2 # Waiting time in seconds.

# Variables for the process.
cmd="new-user.sh" # Script for password change.
device_rootfs="/dev/mmcblk0p2" # Device to search.
folder_rootfs="/tmp/rootfs" # Temporary folder for mount point.
folder_tools="/opt/tools" # Folder where process tools are stored.

# Function to log error events.
# Input: receives error code and a message about the event.
# Output: displays date, error code, and event message on the screen.
function logger() {
	local exit_code=$1
	local message=$2
	local date=$(date "+%Y-%m-%d %H:%M:%S")
	printf "%s - exit:%s - %s\n" "$date" "$exit_code" "$message"
	exit "$exit_code"
}

# Function to mount partitions to a specific folder.
# Input: receives the partition to mount and the destination folder for the mount point.
function mount_partition_to_folder() {
	local partition=$1
	local folder=$2
	# If the mount point exists, unmount it.
	sudo umount "$folder" &>/dev/null
	# Mount the partition to the specified folder.
	printf "Mounting partition %s to %s\n" "$partition" "$folder"
	sudo mount "$partition" "$folder"
	# Check the result of the operation.
	if [ $? -ne 0 ]; then
		logger 1 "Error: Mounting partition \"$partition\" to \"$folder\""
	fi
}

# Iterative loop to check if the defined device (device_rootfs) exists.
# Output: creates a user (username) with a specific password (password) in the file system of the device (device_rootfs). If the user exists, it changes their password (password).
is_device_exists=false # Determines if the device exists.
while ! $is_device_exists && [ "$try" -le "$max_try" ]; do
	# Check if the device exists.
	if [ -e "$device_rootfs" ]; then
		clear
		# Start the configuration process.
		printf "Starting configuration process...\n"
		# Copy the script to the new location.
		script="$folder_tools/$cmd"
		# Create temporary folder for mounting "rootfs".
		sudo mkdir -p "$folder_rootfs"
		# Mount the "rootfs" partition.
		mount_partition_to_folder "$device_rootfs" "$folder_rootfs"
		# Create folder to store process tools.
		sudo mkdir -p "$folder_rootfs/$folder_tools"
		# Copy the script for password change.
		sudo cp "$script" "$folder_rootfs/$folder_tools"
		# Create the user or change the password of an existing user in the external operating system.
		sudo chroot "$folder_rootfs" /bin/bash -c "$script $username $password"
		# Unmount the used folder and release the device.
		sudo umount "$folder_rootfs"
		# Set the status of the device.
		is_device_exists=true
		printf "Process finished.\n"
	else
		# Display the attempt number and request to insert the device.
		printf "[%s/%s] Please insert the storage device...\n" "$try" "$max_try"
	fi
	# Increment the iteration counter by 1.
	((try++))
	# Waiting time before iterating again.
	sleep "$timeout"
done

# Evaluate the result and display an error if the device is not found.
if [ "$try" -eq "$max_try" ] && [ ! -e "$is_device_exists" ]; then
	clear
	printf "Attention: Unable to detect the storage device.\n"
	exit 1
fi