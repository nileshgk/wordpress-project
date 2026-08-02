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