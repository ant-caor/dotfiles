#!/bin/bash

# Define Terraform version
TERRAFORM_VERSION="1.6.0"

# Detect OS and Architecture
OS="darwin"
ARCH="arm64"

# Download Terraform binary
TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_${OS}_${ARCH}.zip"
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}"

echo "Downloading Terraform from $TERRAFORM_URL"
curl -O $TERRAFORM_URL

# Unzip and move to /usr/local/bin
unzip $TERRAFORM_ZIP
sudo mv terraform /usr/local/bin/

# Clean up
rm $TERRAFORM_ZIP

echo "Terraform installed successfully."

# Verify installation
terraform version
