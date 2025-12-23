#!/bin/bash

set -e

cd "$(dirname "$0")/../terraform"

if [ ! -d ".terraform" ]; then
    echo "Terraform not initialized. Nothing to destroy."
    exit 1
fi

echo "This will destroy all resources including:"
echo "   - S3 buckets and their contents"
echo "   - Lambda function and layers"
echo "   - API Gateway"
echo "   - IAM roles and policies"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Destruction cancelled."
    exit 0
fi

terraform destroy -auto-approve

echo "All resources destroyed successfully!"