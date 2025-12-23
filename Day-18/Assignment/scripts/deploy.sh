#!/bin/bash

set -e

command -v aws >/dev/null 2>&1 || { echo "AWS CLI not installed. Please install it first."; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "Terraform not installed. Please install it first."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker not installed. Please install it first."; exit 1; }

aws sts get-caller-identity >/dev/null 2>&1 || { echo "AWS credentials not configured."; exit 1; }

cd "$(dirname "$0")/../terraform"

"$(dirname "$0")/build_layer_docker.sh"

terraform init

terraform plan -out=tfplan

terraform apply tfplan

UPLOAD_BUCKET=$(terraform output -raw upload_bucket_name)
PROCESSED_BUCKET=$(terraform output -raw processed_bucket_name)
WEBSITE_BUCKET=$(terraform output -raw website_bucket_name)
WEBSITE_URL=$(terraform output -raw website_url)
API_URL=$(terraform output -raw api_gateway_url)

"$(dirname "$0")/upload_website.sh" "$WEBSITE_BUCKET"

echo ""
echo "Deployment complete!"
echo ""
echo "Upload Bucket: $UPLOAD_BUCKET"
echo "Processed Bucket: $PROCESSED_BUCKET"
echo "Website Bucket: $WEBSITE_BUCKET"
echo "Website URL: http://$WEBSITE_URL"
echo "API Gateway URL: $API_URL"
echo ""
echo "To upload an image via S3:"
echo "aws s3 cp your-image.jpg s3://$UPLOAD_BUCKET/"
echo ""
echo "To access the web interface:"
echo "http://$WEBSITE_URL"
echo ""
echo "To destroy resources:"
echo "$(dirname "$0")/destroy.sh"