#!/bin/bash

# ==============================================================================
# This script is used to mount the boot and rootfs partitions of a Raspberry Pi OS system into specific folders.
# It first identifies the boot and rootfs partitions, then creates folders for the mount points.
# After mounting the partitions, it opens the file explorer to display the contents of the mount points.
# If any errors occur during the process, it logs the error and exits with an error code.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Variables for partition strings and base directory path
boot_str="boot"
rootfs_str="rootfs"
basedir_path="/tmp"
boot_partition=$(sudo blkid | grep /dev/sd | grep $boot_str | awk '{print $1}' | tr -d ':','')
rootfs_partition=$(sudo blkid | grep /dev/sd | grep $rootfs_str | awk '{print $1}' | tr -d ':','')

# Function to log error events.
# Input: error code and event message.
# Output: displays the date, error code, and event message.
function logger (){
	exit_code=$1
	message=$2
	date=$(date "+%Y-%m-%d %H:%M:%S")
	echo "$date - exit: $exit_code - $message"
	exit $exit_code
}

# Function to mount partitions to a specific folder.
# Input: partition to mount and destination folder for the mount point.
function mount_partition_to_folder (){
	partition=$1 ; folder=$2
	# Unmount the mount point if it exists.
	sudo umount $folder &>/dev/null
	# Mount the partition to a specific folder.
	echo "Mounting partition $partition to $folder"
	sudo mount $partition $folder
	# Check the result of the operation.
	if [ $? -ne 0 ]; then logger 1 "Error: Mounting partition \"$partition\" to \"$folder\""; fi
}

# Check the "boot" partition
# If the check fails, execution stops.
echo "Checking partition: $boot_str"
if [ -z $boot_partition ]; then
	logger 1 "Error: Partition \"$boot_str\" not found."
fi

# Check the "rootfs" partition
# If the check fails, execution stops.
echo "Checking partition: $rootfs_str"
if [ -z $rootfs_partition ]; then
	logger 1 "Error: Partition \"$rootfs_str\" not found."
fi

# Create directories for the mount points
echo "Creating folders for the mount points"
mkdir -p $basedir_path/{$boot_str,$rootfs_str}

# Mount the "boot" partition
mount_partition_to_folder $boot_partition $basedir_path/$boot_str

# Mount the "rootfs" partition
mount_partition_to_folder $rootfs_partition $basedir_path/$rootfs_str

# Open the file explorer displaying the contents of the mount points.
nautilus {$basedir_path/$boot_str,$basedir_path/$rootfs_str}
echo "Configuration process completed."