#!/bin/bash

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt-get update
sudo apt-get upgrade -y

# Install dependencies for Docker
echo "Installing dependencies..."
sudo apt-get install ca-certificates curl gnupg git -y

# Install Docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker ubuntu   #my case is ubuntu
newgrp docker
sudo chmod 777 /var/run/docker.sock

# Install Sonarqube 
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

#install trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

# Install Docker Compose (latest version)
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker, Docker Compose, SonarQube, Trivy installation
echo "Docker and Docker Compose installation verification:"
docker --version
docker-compose --version
sonarqube --version
trivy --version

echo "Automation Docker Install script completed."


# Variables
REPO_URL="https://github.com/Atanub707/wanderlust.git"
CLONE_DIR="/home/ubuntu/wanderlust"
BRANCH_NAME="dev"  # Replace with the name of the branch you want to switch to

# Clone the repository (replace with your actual repository URL)
if [ ! -d "$CLONE_DIR" ]; then
    echo "Cloning the repository..."
    git clone $REPO_URL $CLONE_DIR
else
    echo "Repository already exists. Pulling the latest code..."
    git -C $CLONE_DIR pull
fi

# Navigate to the directory containing the repository
cd $CLONE_DIR

# Checkout the specified branch
echo "Switching to branch $BRANCH_NAME..."
git checkout $BRANCH_NAME

# Pull the latest changes for the branch
echo "Pulling the latest changes for branch $BRANCH_NAME..."
git pull origin $BRANCH_NAME

# Prune Docker images and containers
echo "Pruning Docker system..."
docker system prune -af

# Add a delay to ensure Docker images and containers are properly deleted
echo "Waiting for Docker cleanup to complete..."
sleep 30

# Build and run Docker containers using Docker Compose
echo "Building and running Docker containers using Docker Compose..."
docker-compose up -d --build

# List all Docker images
echo "Listing all Docker images..."
docker images

# List all Docker containers (both running and stopped)
echo "Listing all Docker containers..."
docker ps -a

echo "Automation script completed. Please log out and log back in for the Docker group changes to take effect."
