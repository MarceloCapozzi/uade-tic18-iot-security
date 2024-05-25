#!/bin/bash

# ==============================================================================
# This script is used to disable iptables on a system.
# It first flushes all chains, deletes all chains, and sets the default policies.
# It then flushes all chains in all tables.
# Author: Marcelo Capozzi (https://github.com/MarceloCapozzi)
# Date: 2024-05-19
# ==============================================================================

# Disable iptables
# Flush all chains
sudo iptables -F

# Delete all chains
sudo iptables -X

# Set default policies
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Set zero the packet and byte counters in all chains
sudo iptables -Z

# Flush all chains in all tables
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -t raw -F
sudo iptables -t raw -X

# completion message
echo "Iptables have been successfully disabled."