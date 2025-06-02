#!/bin/bash

# Set non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Update system
sudo apt update

# Install nginx without interactive prompts
sudo DEBIAN_FRONTEND=noninteractive apt install -y nginx

# Enable and start nginx
sudo systemctl enable nginx
sudo systemctl start nginx

