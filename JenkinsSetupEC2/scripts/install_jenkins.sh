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

#Install Docker Compose plugin
apt install -y docker-compose-v2

systemctl enable docker
systemctl start docker

# Allow Jenkins and Ubuntu user to use Docker
groupadd -f docker
usermod -aG docker jenkins
usermod -aG docker ubuntu
usermod -aG docker ubuntu

# Verify Docker
docker --version

#############################################
# Install Python Packages
#############################################

apt install -y \
python3 \
python3-pip \
python3-venv

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
# Install AWS CLI v2
#############################################

cd /tmp

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip

unzip -oq awscliv2.zip

./aws/install --update

rm -rf aws awscliv2.zip

aws --version

type -p curl >/dev/null || apt install curl -y

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
| dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
| tee /etc/apt/sources.list.d/github-cli.list

apt update

apt install gh -y

JENKINS_PLUGIN_CLI=/usr/lib/jenkins-plugin-manager.jar

java -jar $JENKINS_PLUGIN_CLI \
  --plugins \
  git \
  github \
  pipeline-stage-view \
  workflow-aggregator \
  terraform \
  ansible \
  docker-workflow \
  blueocean

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

#############################################
# Jenkins Passwordless Sudo
#############################################

echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins

chmod 440 /etc/sudoers.d/jenkins