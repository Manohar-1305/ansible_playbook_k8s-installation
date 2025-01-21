#!/bin/bash
set -e          # Exit immediately if a command exits with a non-zero status
set -o pipefail # Fail a pipeline if any command fails

# Update package lists
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg

# Create a directory for Docker's keyring
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


# Add Docker's APT repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Update package lists again to include Docker packages
sudo apt-get update -y

# Install Docker and related components
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Adjust permissions for the Docker socket
sudo chmod 666 /var/run/docker.sock

sudo systemctl start docker
sudo systemctl enable docker

# Run SonarQube container
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
