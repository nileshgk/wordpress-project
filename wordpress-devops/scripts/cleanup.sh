#!/bin/bash

set -e

echo "Starting infrastructure cleanup..."

# Verify Terraform directory exists
if [ ! -d "terraform" ]; then
    echo "Error: terraform directory not found."
    exit 1
fi

cd terraform

# Initialize Terraform if required
terraform init

# Destroy infrastructure
terraform destroy -auto-approve

echo "Cleanup completed successfully."