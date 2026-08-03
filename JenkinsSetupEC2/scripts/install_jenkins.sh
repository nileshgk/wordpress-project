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
    zip \
    wget \
    jq \
    tree \
    vim \
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

systemctl enable --now jenkins

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
apt list --installed | grep jenkins

echo "======================================"
echo "Jenkins Installation Completed"
echo "======================================"

#############################################
# Install Docker
#############################################

apt install -y docker.io

#Install Docker Compose plugin
apt install -y docker-compose-plugin || true

systemctl enable --now docker

# Allow Jenkins and Ubuntu user to use Docker
groupadd -f docker

usermod -aG docker jenkins
id jenkins
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

echo "AWS CLI Installed"

aws --version || exit 1

type -p curl >/dev/null || apt install curl -y

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
| dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
| tee /etc/apt/sources.list.d/github-cli.list

apt update

apt install gh -y

mkdir -p /var/lib/jenkins/plugins
mkdir -p /var/lib/jenkins/jobs
mkdir -p /var/lib/jenkins/init.groovy.d
mkdir -p /var/lib/jenkins/secrets
mkdir -p /var/lib/jenkins/.aws
mkdir -p /var/lib/jenkins/workspace

chown -R jenkins:jenkins /var/lib/jenkins


#############################################
# Install Jenkins Plugin Manager
#############################################

wget \
https://github.com/jenkinsci/plugin-installation-manager-tool/releases/latest/download/jenkins-plugin-manager.jar \
-O /opt/jenkins-plugin-manager.jar

java -jar /opt/jenkins-plugin-manager.jar \
    --war /usr/share/java/jenkins.war \
    --plugin-download-directory /var/lib/jenkins/plugins \
    --verbose \
    --plugins \
        git \
        github \
        workflow-aggregator \
        pipeline-stage-view \
        docker-workflow \
        blueocean \
        ansicolor \
        credentials \
        ssh-agent \
        ssh-slaves \
        matrix-auth \
        timestamper \
        ws-cleanup \
        terraform \
        ansible


#############################################
# Restart Jenkins
#############################################
chown -R jenkins:jenkins /var/lib/jenkins/plugins

systemctl daemon-reload
systemctl restart jenkins

echo "Waiting for Jenkins after plugin installation..."

timeout=600
elapsed=0

until curl -fs http://localhost:8080/login >/dev/null
do
    sleep 10
    elapsed=$((elapsed+10))

    if [ "$elapsed" -ge "$timeout" ]; then
        echo "Jenkins failed to start after plugin installation."
        journalctl -u jenkins --no-pager -n 100
        exit 1
    fi
done

echo "========================================"

echo "Git Version"
git --version

echo "----------------------------------------"

echo "Java Version"
java -version

echo "----------------------------------------"

echo "Jenkins Version"
apt list --installed | grep jenkins

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
which aws
aws --version

echo "========================================"

echo "Jenkins Server Setup Completed Successfully"

#############################################
# Jenkins Passwordless Sudo
#############################################

echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins

chmod 440 /etc/sudoers.d/jenkins