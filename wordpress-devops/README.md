## Prerequisites

- Jenkins installed
- Git installed
- Terraform installed
- Ansible installed
- Docker installed
- AWS CLI configured

Jenkins plugins to install
Manage Jenkins
    ↓
Plugins
    ↓
Available Plugins: 
Install:
✅ AnsiColor
✅ GitHub Integration Plugin
✅ Git Plugin
✅ Pipeline Plugin
✅ Git
✅ Docker Pipeline
✅ SSH Agent
✅ Terraform

Create the SSH Credential(run the cmd on terraform dir to create private key: ssh-keygen -t rsa -b 2048 -f wordpress-key )

Fill in:
Kind: SSH Username with private key
Scope: Global
ID: wordpress-ssh-key
Username: ubuntu
Private Key: Enter directly
Paste the contents of your private key (wordpress-key).

# WordPress DevOps Automation using Terraform, Jenkins, Ansible & Docker

## Project Overview

This project demonstrates a complete **DevOps CI/CD pipeline** to provision infrastructure and deploy a **WordPress application** on AWS using modern DevOps tools.

The infrastructure is provisioned using **Terraform**, the deployment is automated using **Ansible**, containers are managed with **Docker Compose**, and the entire workflow is orchestrated through **Jenkins**.

This project follows Infrastructure as Code (IaC) and Configuration Management best practices.

---

# Architecture

```
                           GitHub Repository
                                  │
                                  ▼
                           Jenkins Pipeline
                                  │
              ┌───────────────────┴───────────────────┐
              │                                       │
              ▼                                       ▼
      Terraform Provisioning                 Generate Inventory
              │                                       │
              ▼                                       ▼
      AWS Infrastructure                    Ansible Configuration
              │                                       │
              └───────────────┬───────────────────────┘
                              ▼
                       Ubuntu EC2 Instance
                              │
                     Install Docker Engine
                              │
                     Docker Compose Deploy
                              │
              ┌───────────────┴────────────────┐
              ▼                                ▼
          MySQL Container             WordPress Container
                              │
                              ▼
                           Nginx
                              │
                              ▼
                        Browser Access
```

---

# Technologies Used

## Cloud

- AWS EC2
- AWS VPC
- AWS Security Groups
- AWS S3 Backend
- DynamoDB

## Infrastructure as Code

- Terraform

## Configuration Management

- Ansible

## CI/CD

- Jenkins

## Containers

- Docker
- Docker Compose

## Operating System

- Ubuntu 24.04 LTS

## Application

- WordPress
- MySQL
- Nginx

---

# Project Structure

```
wordpress-devops/
│
├── Jenkinsfile
├── README.md
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
├── ansible/
│   ├── ansible.cfg
│   ├── inventory
│   ├── playbook.yml
│   │
│   ├── group_vars/
│   │   └── all.yml
│   │
│   └── roles/
│       ├── docker/
│       ├── wordpress/
│       └── nginx/
│
├── scripts/
│   ├── generate_inventory.sh
│   └── cleanup.sh
│
└── .gitignore
```

---

# Features

- Infrastructure Provisioning using Terraform
- Remote Terraform State in S3
- Terraform State Locking
- Automatic Inventory Generation
- Automated Docker Installation
- Automated WordPress Deployment
- Automated MySQL Deployment
- Automated Nginx Configuration
- Docker Compose Deployment
- Jenkins CI/CD Pipeline
- Secure Variable Management using Ansible Variables
- Automatic Cleanup Script
- SSH Key Authentication

---

# Infrastructure Created

Terraform provisions the following AWS resources:

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- Ubuntu EC2 Instance
- SSH Key Pair
- 30 GB GP3 Root Volume

---

# Prerequisites

Before running this project, ensure the following are available:

- AWS Account
- Jenkins Server
- Terraform
- Ansible
- Docker
- Git
- AWS CLI

Configure AWS CLI

```bash
aws configure
```

Verify

```bash
aws sts get-caller-identity
```

---

# Deployment Flow

## Step 1

Provision Jenkins Infrastructure

Use the **jenkins-terraform-aws** repository.

Deploy

- S3 Backend
- DynamoDB
- Jenkins Server

---

## Step 2

Create Jenkins Pipeline

Configure Jenkins to connect with this repository.

---

## Step 3

Pipeline Execution

The Jenkins pipeline performs the following stages:

```
Checkout Source Code

↓

Terraform Init

↓

Terraform Validate

↓

Terraform Plan

↓

Terraform Apply

↓

Generate Inventory

↓

Ansible Ping

↓

Install Docker

↓

Deploy WordPress

↓

Deploy MySQL

↓

Configure Nginx

↓

Deployment Complete
```

---

# Terraform Commands

Initialize

```bash
terraform init
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan
```

Apply

```bash
terraform apply
```

Destroy

```bash
terraform destroy
```

---

# Generate Inventory

```bash
./scripts/generate_inventory.sh
```

Example

```
[wordpress]

54.xxx.xxx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/keys/wordpress.pem
```

---

# Verify Connection

```bash
cd ansible

ansible wordpress -m ping
```

Expected Output

```
SUCCESS
```

---

# Deploy Application

```bash
ansible-playbook playbook.yml
```

---

# Verify Docker

```bash
docker ps
```

Expected Containers

```
mysql

wordpress
```

---

# Access Application

Open Browser

```
http://<EC2-PUBLIC-IP>
```

Complete the WordPress installation wizard.

---

# Cleanup

Destroy AWS Infrastructure

```bash
./scripts/cleanup.sh
```

or

```bash
cd terraform

terraform destroy
```

---

# Security Best Practices

- Terraform Remote State
- State Locking
- Encrypted GP3 Volume
- IMDSv2 Enabled
- SSH Key Authentication
- Configuration Management with Ansible
- Variables stored in `group_vars/all.yml`
- Secrets excluded using `.gitignore`

---

# Future Enhancements

- HTTPS using Let's Encrypt
- AWS Route53 Integration
- AWS ACM Certificate
- Docker Hub Image Push
- AWS ECR Integration
- Kubernetes Deployment
- ArgoCD GitOps
- SonarQube
- Trivy Security Scan
- Prometheus Monitoring
- Grafana Dashboard
- Slack Notifications

---

# Learning Outcomes

Through this project you will learn:

- Infrastructure as Code (Terraform)
- Remote State Management
- AWS Networking
- EC2 Provisioning
- Ansible Configuration Management
- Docker & Docker Compose
- Jenkins CI/CD
- WordPress Deployment
- Linux Administration
- SSH Automation
- DevOps Best Practices

---

# Author

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
- Nginx
