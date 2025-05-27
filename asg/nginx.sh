#!/bin/sh
sudo apt update -y  && sudo apt upgrade -y
sudo apt install nginx -y

# Start Nginx service
sudo systemctl start nginx
sudo apt install nginx -y

# Start Nginx service
sudo systemctl start nginx

# Enable Nginx to start automatically on boot
sudo systemctl enable nginx
