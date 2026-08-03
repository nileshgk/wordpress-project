#!/bin/bash

# Exit if any command fails
set -e

echo "Generating Ansible inventory..."

# Verify Terraform directory exists
if [ ! -d "terraform" ]; then
    echo "Error: terraform directory not found."
    exit 1
fi

# Get EC2 public IP from Terraform output
IP=$(terraform -chdir=terraform output -raw public_ip)

# Verify IP was returned
if [ -z "$IP" ]; then
    echo "Error: Unable to retrieve EC2 public IP."
    exit 1
fi

# Generate inventory file
cat > ansible/inventory <<EOF
[wordpress]
$IP

[wordpress:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=../terraform/keys/wordpress.pem
EOF

echo "Inventory generated successfully."
echo

cat ansible/inventory