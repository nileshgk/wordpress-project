#!/bin/bash

# Exit if any command fails
set -e

# Update Ubuntu packages
apt-get update -y
apt-get upgrade -y

# Install common packages
apt-get install -y \
    git \
    curl \
    unzip \
    wget \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates

# Install Java 21
apt-get install -y openjdk-21-jdk

# Install Jenkins
wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
> /etc/apt/sources.list.d/jenkins.list

apt-get update -y
apt-get install -y jenkins

# Enable Jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Docker
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Allow Jenkins to use Docker
usermod -aG docker jenkins
usermod -aG docker ubuntu

# Install Docker Compose Plugin
apt-get install -y docker-compose-v2

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo \
"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
> /etc/apt/sources.list.d/hashicorp.list

apt-get update -y

apt-get install -y terraform

# Install Ansible
add-apt-repository --yes ppa:ansible/ansible

apt-get update -y

apt-get install -y ansible

# Restart Jenkins
systemctl restart jenkins

# Display versions
java -version
jenkins --version || true
docker --version
terraform version
ansible --version
aws --version
git --version