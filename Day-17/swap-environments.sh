#!/bin/bash

# Swap Environments Script for Blue-Green Deployment Demo
# This script performs the CNAME swap between blue and green environments

# Read Terraform outputs to get environment names
BLUE_ENV=$(terraform output -raw blue_environment_name)
GREEN_ENV=$(terraform output -raw green_environment_name)
REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")

echo "Blue-Green Environment Swap Script"
echo "=================================="
echo "Blue Environment: $BLUE_ENV"
echo "Green Environment: $GREEN_ENV"
echo "Region: $REGION"
echo ""

# Ask for confirmation
read -p "Do you want to swap the environment URLs? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Swap cancelled."
    exit 1
fi

echo "Performing CNAME swap..."
aws elasticbeanstalk swap-environment-cnames \
  --source-environment-name "$BLUE_ENV" \
  --destination-environment-name "$GREEN_ENV" \
  --region "$REGION"

if [ $? -eq 0 ]; then
    echo "Swap completed successfully!"
    echo ""
    echo "Note: It may take 1-2 minutes for DNS changes to propagate."
    echo "The URLs have been swapped:"
    echo "  - Blue environment now points to Green application"
    echo "  - Green environment now points to Blue application"
else
    echo "Swap failed. Please check AWS CLI configuration and permissions."
    exit 1
fi