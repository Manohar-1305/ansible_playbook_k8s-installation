#!/bin/bash

# Define log file
LOG_FILE="/var/log/jenkins_install.log"

# Ensure the log directory exists and set permissions
sudo mkdir -p "$(dirname "$LOG_FILE")"
sudo touch "$LOG_FILE"
sudo chmod 644 "$LOG_FILE"

# Redirect output and errors to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting Jenkins installation process: $(date)"

# Update package list
echo "Updating package list..."
sudo apt update -y

# Install OpenJDK 21 JRE
echo "Installing OpenJDK 21 JRE..."
sudo apt install openjdk-21-jre -y

# Download and add Jenkins key
echo "Downloading Jenkins GPG key..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "Adding Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

# Update package list again
echo "Updating package list for Jenkins repository..."
sudo apt-get update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install jenkins -y

echo "Jenkins installation process completed: $(date)"
