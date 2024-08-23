#!/bin/bash

# Update the package index
echo "Updating package index..."
sudo yum update -y

# Install httpd (Apache)
echo "Installing httpd..."
sudo yum install httpd -y

# Start the httpd service
echo "Starting httpd service..."
sudo systemctl start httpd

# Enable httpd to start on boot
echo "Enabling httpd to start on boot..."
sudo systemctl enable httpd

# Open HTTP port 80 in the firewall (if applicable)
echo "Allowing HTTP traffic on port 80..."
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Restart httpd service
echo "Restarting httpd Service..."
sudo systemctl restart httpd

# Confirm httpd service status
echo "Checking httpd service status..."
sudo systemctl status httpd

echo "httpd installation and configuration complete."
