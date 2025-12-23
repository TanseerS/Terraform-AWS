#!/bin/bash

# Deploy script for Image Processor with API Gateway and Web Frontend
# This script handles the complete deployment process

set -e

echo "🚀 Starting deployment of Image Processor..."

# Check prerequisites
echo "🔍 Checking prerequisites..."
command -v aws >/dev/null 2>&1 || { echo "❌ AWS CLI not installed. Please install it first."; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform not installed. Please install it first."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Docker not installed. Please install it first."; exit 1; }

aws sts get-caller-identity >/dev/null 2>&1 || { echo "❌ AWS credentials not configured."; exit 1; }

echo "✅ Prerequisites check passed"

# Navigate to terraform directory
cd "$(dirname "$0")/../terraform"

# Build Lambda layer
echo "📦 Building Lambda layer..."
"$(dirname "$0")/build_layer_docker.sh"

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Plan deployment
echo "📋 Planning deployment..."
terraform plan -out=tfplan

# Apply deployment
echo "🚀 Applying deployment..."
terraform apply tfplan

# Get outputs
echo "📊 Getting deployment outputs..."
UPLOAD_BUCKET=$(terraform output -raw upload_bucket_name)
PROCESSED_BUCKET=$(terraform output -raw processed_bucket_name)
WEBSITE_BUCKET=$(terraform output -raw website_bucket_name)
WEBSITE_URL=$(terraform output -raw website_url)
API_URL=$(terraform output -raw api_gateway_url)

# Upload website files
echo "🌐 Uploading website files..."
"$(dirname "$0")/upload_website.sh" "$WEBSITE_BUCKET"

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📋 Deployment Summary:"
echo "Upload Bucket: $UPLOAD_BUCKET"
echo "Processed Bucket: $PROCESSED_BUCKET"
echo "Website Bucket: $WEBSITE_BUCKET"
echo "Website URL: http://$WEBSITE_URL"
echo "API Gateway URL: $API_URL"
echo ""
echo "📸 To upload an image via S3:"
echo "aws s3 cp your-image.jpg s3://$UPLOAD_BUCKET/"
echo ""
echo "🌐 To access the web interface:"
echo "http://$WEBSITE_URL"
echo ""
echo "🧹 To destroy resources:"
echo "$(dirname "$0")/destroy.sh"