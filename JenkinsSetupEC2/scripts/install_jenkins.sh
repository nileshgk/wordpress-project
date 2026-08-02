#!/bin/bash

# Exit on error, undefined variables and pipeline failures
set -euxo pipefail

# Save installation logs
exec > >(tee /var/log/install_jenkins.log) 2>&1

#############################################
# Update Ubuntu Packages
#############################################

apt update -y
apt upgrade -y

#############################################
# Install Required Packages
#############################################

apt install -y \
    git \
    curl \
    unzip \
    wget \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    fontconfig

#############################################
# Install Java 21 (JDK)
#############################################

apt install -y openjdk-21-jdk

# Verify Java Installation
java -version

#############################################
# Create APT Keyring Directory
#############################################

mkdir -p /etc/apt/keyrings

#############################################
# Download Jenkins GPG Key
#############################################
# Download Jenkins GPG Key (2026)
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

#############################################
# Add Jenkins Repository
#############################################

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
tee /etc/apt/sources.list.d/jenkins.list > /dev/null

#############################################
# Update Package Index
#############################################

apt update -y

#############################################
# Install Jenkins
#############################################

apt install -y jenkins

#############################################
# Enable & Start Jenkins
#############################################

systemctl enable jenkins
systemctl start jenkins

#############################################
# Verify Jenkins Status
#############################################

systemctl status jenkins --no-pager

#############################################
# Display Installed Versions
#############################################

echo "======================================"
echo "Java Version"
java -version

echo "======================================"
echo "Jenkins Version"
jenkins --version || true

echo "======================================"
echo "Jenkins Installation Completed"
echo "======================================"

#############################################
# Install Docker
#############################################

apt install -y docker.io

systemctl enable docker
systemctl start docker

# Allow Jenkins and Ubuntu user to use Docker
usermod -aG docker jenkins
usermod -aG docker ubuntu

# Verify Docker
docker --version

#############################################
# Install Terraform
#############################################

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list

apt update

apt install -y terraform

# Verify Terraform
terraform version

#############################################
# Install Ansible
#############################################

apt install -y ansible

# Verify Ansible
ansible --version

#############################################
# Install AWS CLI
#############################################

apt install -y awscli

# Verify AWS CLI
aws --version

#############################################
# Restart Jenkins
#############################################

systemctl restart jenkins

echo "========================================"

echo "Git Version"
git --version

echo "----------------------------------------"

echo "Java Version"
java -version

echo "----------------------------------------"

echo "Jenkins Version"
jenkins --version || true

echo "----------------------------------------"

echo "Docker Version"
docker --version

echo "----------------------------------------"

echo "Terraform Version"
terraform version

echo "----------------------------------------"

echo "Ansible Version"
ansible --version

echo "----------------------------------------"

echo "AWS CLI Version"
aws --version

echo "========================================"

echo "Jenkins Server Setup Completed Successfully"