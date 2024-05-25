#!/bin/bash

# ==============================================================================
# This script is used to create a new user on a system and add it to the sudo group.
# It first validates the input parameters, then checks if the script is running with root privileges.
# It then verifies if the user exists and if Python3 is installed.
# If the user exists, it updates the user's information; otherwise, it creates a new user.
# The script then displays the username and password and exits the process.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

username="$1" # Receives the username as a parameter.
password_str="$2" # Receives the password for the user (username).
username_len_min=4 # Minimum number of characters for the username.
password_len_min=6 # Minimum number of characters for the user's password.
sudo_group="sudo" # Group to which the user (username) will be added.

# Validates that the variables are not null.
if [ -z "$username" ] || [ -z "$password_str" ]; then
	# Error message for missing username or password.
	echo "Error: you must specify a username and a password."
	exit 1
fi

# Determines the number of characters in the variables.
username_len=$(echo -n "$username" | wc -c)
password_str_len=$(echo -n "$password_str" | wc -c)

# Evaluates the minimum number of characters for the variables.
if [ $username_len -lt $username_len_min ] || [ $password_str_len -lt $password_len_min ]; then
	# Error message for not meeting the minimum length requirement for the variables.
	echo "Error: incorrect number of minimum characters for the username ($username_len_min) or the password ($password_len_min)."
	exit 1
fi

# Verifies if the script is running with root privileges.
if [ $(id -u) -ne 0 ]; then
	# Error message for not running the script with root privileges.
	echo "Error: this script must be run with root privileges." ; exit 1
else
	# Verifies if the user exists.
	is_user_exists=$(id $username 1>/dev/null 2>/dev/null && echo true || echo false)

	# Verifies if python3 is installed.
	if ! command -v python3 &> /dev/null; then
		echo "Error: Python3 is not installed. Please install it before running this script."
		exit 1
	fi

	# Converts the received password into a valid password format for the operating system.
	password=$(python3 -c "import crypt; print(crypt.crypt('$password_str'))" 2>/dev/null)
	
	# Verifies if the password was generated successfully.
	if [ $? -ne 0 ]; then  echo "Error: failed to generate the password." ; exit 1 ; fi
	
	# Verifies if the user exists.
	if $is_user_exists; then
		echo "Updating existing user..."
		usermod $username -G $sudo_group --password $password
	else
		echo "Creating a new user..."
		useradd $username -G $sudo_group --password $password
	fi

	# Displays the made change and exits the process.
	clear
	echo "The username is: $username and the password is: $password_str"
	sleep 10
	exit 0
fi

# Completion message
echo "User creation process completed."