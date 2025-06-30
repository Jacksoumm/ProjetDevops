#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if SSH key exists
if [ -z "$SSH_KEY_PATH" ]; then
  print_error "SSH_KEY_PATH environment variable is not set."
  print_message "Please set it to the path of your SSH private key:"
  print_message "export SSH_KEY_PATH=/path/to/your/key.pem"
  exit 1
fi

# Check if AWS credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  print_error "AWS credentials are not set."
  print_message "Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables:"
  print_message "export AWS_ACCESS_KEY_ID=your_access_key"
  print_message "export AWS_SECRET_ACCESS_KEY=your_secret_key"
  exit 1
fi

# Directory paths
TERRAFORM_DIR="./terraform"
ANSIBLE_DIR="./ansible"

# Step 1: Initialize and validate Terraform
print_message "Initializing Terraform..."
cd $TERRAFORM_DIR
terraform init

print_message "Validating Terraform configuration..."
terraform validate

# Step 2: Run TFLint for linting
print_message "Running TFLint..."
if command -v tflint &> /dev/null; then
  tflint
else
  print_warning "TFLint not found. Skipping linting."
  print_message "To install TFLint, follow instructions at: https://github.com/terraform-linters/tflint"
fi

# Step 3: Run Checkov for security checks
print_message "Running Checkov for security checks..."
if command -v checkov &> /dev/null; then
  checkov -d .
else
  print_warning "Checkov not found. Skipping security checks."
  print_message "To install Checkov: pip install checkov"
fi

# Step 4: Generate Terraform plan
print_message "Generating Terraform plan..."
terraform plan -out=tfplan

# Step 5: Ask for confirmation before applying
read -p "Do you want to apply the Terraform plan? (yes/no): " APPLY_TERRAFORM

if [[ $APPLY_TERRAFORM != "yes" ]]; then
  print_message "Terraform apply aborted."
  exit 0
fi

# Step 6: Apply Terraform plan
print_message "Applying Terraform plan..."
terraform apply tfplan

# Step 7: Get outputs for Ansible
print_message "Getting outputs for Ansible..."
COMBINED_IP=$(terraform output -raw combined_public_ip)

# Step 8: Wait for instance to be ready
print_message "Waiting for instance to be ready..."
sleep 60

# Step 9: Run Ansible playbooks
print_message "Running Ansible playbooks..."
cd ../$ANSIBLE_DIR

# Export variables for Ansible
export combined_ip=$COMBINED_IP
# For backward compatibility with playbooks
export frontend_ip=$COMBINED_IP
export backend_ip=$COMBINED_IP
export ssh_key_path=$SSH_KEY_PATH

# Run backend playbook first
print_message "Configuring backend server..."
ansible-playbook backend_playbook.yml

# Then run frontend playbook
print_message "Configuring frontend server..."
ansible-playbook frontend_playbook.yml

print_message "Deployment completed successfully!"
print_message "Application URL: http://$COMBINED_IP"
