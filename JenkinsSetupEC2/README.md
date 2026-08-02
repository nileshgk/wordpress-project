# Jenkins Infrastructure Automation using Terraform on AWS

## Project Overview

This project provisions a complete Jenkins server on AWS using **Terraform Infrastructure as Code (IaC)**. The Jenkins server is automatically configured using a bootstrap script (`user_data`) that installs all the required DevOps tools.

This repository serves as the **foundation infrastructure** for future DevOps projects such as WordPress deployment, Kubernetes, CI/CD pipelines, Docker, and Ansible automation.

---

## Architecture

```
                    AWS Cloud
                        │
                ┌───────────────┐
                │      VPC      │
                └───────┬───────┘
                        │
                Public Subnet
                        │
                Security Group
                        │
                Ubuntu EC2 Instance
                        │
          install_jenkins.sh (User Data)
                        │
      ┌─────────────────┼─────────────────┐
      │                 │                 │
      ▼                 ▼                 ▼
   Jenkins          Docker          Terraform
      │
      ├──────────────┐
      ▼              ▼
  Ansible        AWS CLI
```

---

## Technologies Used

- AWS EC2
- AWS VPC
- AWS Security Groups
- AWS Internet Gateway
- AWS S3 Backend
- Terraform
- Jenkins
- Docker
- Ansible
- Git
- AWS CLI
- Ubuntu 24.04 LTS
- OpenJDK 21

---

## Project Structure

```
Jenkins/
│
├── backend/
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── s3.tf
│   └── outputs.tf
│
├── terraform/
│   ├── provider.tf
│   ├── backend.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── data.tf
│   ├── network.tf
│   ├── security.tf
│   ├── ec2.tf
│   └── outputs.tf
│
├── scripts/
│   └── install_jenkins.sh
│
├── keys/
│
├── .gitignore
└── README.md
```

---

## Features

- Infrastructure as Code using Terraform
- Automated Jenkins installation
- Automated Docker installation
- Automated Terraform installation
- Automated Ansible installation
- Automated AWS CLI installation
- Automatic SSH Key Pair generation
- Remote Terraform State using S3
- State Locking using DynamoDB
- Encrypted 30 GB GP3 Root Volume
- Ubuntu 24.04 LTS
- OpenJDK 21
- IMDSv2 Enabled
- Public Subnet with Internet Access

---

## AWS Resources Created

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- EC2 Instance
- SSH Key Pair
- 30 GB GP3 Root Volume
- S3 Bucket
- DynamoDB Lock Table

---

## Prerequisites

Before deploying, install:

- Terraform
- AWS CLI
- Git

Configure AWS CLI:

```bash
aws configure
```

Verify credentials:

```bash
aws sts get-caller-identity
```

---

# Deployment Guide

## Step 1: Clone Repository

```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/jenkins.git

cd jenkins
```

---

## Step 2: Create Terraform Backend

```bash
cd backend

terraform init

terraform validate

terraform plan

terraform apply
```

This creates:

- S3 Bucket
- DynamoDB Lock Table

---

## Step 3: Deploy Jenkins Infrastructure

```bash
cd ../terraform

terraform init

terraform validate

terraform fmt -recursive

terraform plan

terraform apply
```

Terraform provisions:

- VPC
- Subnet
- Security Group
- Internet Gateway
- EC2 Instance
- Jenkins Server

---

## Step 4: Wait for Installation

Terraform launches the EC2 instance.

The User Data script automatically installs:

- Java 21
- Jenkins
- Docker
- Terraform
- AWS CLI
- Git
- Ansible

Installation takes approximately **5–10 minutes**.

---

## Step 5: Access Jenkins

```bash
terraform output
```

Example:

```
jenkins_url = http://54.xxx.xxx.xxx:8080
```

Open the URL in your browser.

Retrieve the initial admin password:

```bash
ssh -i keys/jenkins.pem ubuntu@<PUBLIC-IP>

sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## Verify Installed Tools

```bash
java -version

jenkins --version

docker --version

terraform version

ansible --version

aws --version

git --version
```

---

## Cleanup

Destroy the Jenkins infrastructure:

```bash
cd terraform

terraform destroy
```

Destroy the backend (only if no longer needed):

```bash
cd ../backend

terraform destroy
```

---

## Security Best Practices

- IMDSv2 Enabled
- Encrypted GP3 Root Volume
- Remote Terraform State
- State Locking Enabled
- Automatic SSH Key Generation
- Infrastructure as Code
- Version Controlled

---

## Future Enhancements

- GitHub Webhooks
- Docker Pipeline
- SonarQube Integration
- Trivy Image Scanning
- AWS ECR
- Kubernetes Deployment
- ArgoCD
- Prometheus
- Grafana
- Slack Notifications

---

## Author

**Nilesh K**

DevOps Engineer

### Skills

- AWS
- Terraform
- Jenkins
- Docker
- Kubernetes
- Ansible
- Linux
- Git
- CI/CD