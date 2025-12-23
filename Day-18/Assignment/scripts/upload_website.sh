#!/bin/bash

# Upload website files to S3 bucket
# This script uploads the static website files to the website bucket

set -e

# Check if website bucket is provided
if [ $# -eq 0 ]; then
    echo "❌ Usage: $0 <website-bucket-name>"
    echo "Example: $0 my-website-bucket-12345"
    exit 1
fi

WEBSITE_BUCKET="$1"

echo "🌐 Uploading website files to S3 bucket: $WEBSITE_BUCKET"

# Navigate to www directory
cd "$(dirname "$0")/../www"

# Upload files to S3
aws s3 cp index.html "s3://$WEBSITE_BUCKET/" --content-type "text/html"
aws s3 cp style.css "s3://$WEBSITE_BUCKET/" --content-type "text/css"
aws s3 cp script.js "s3://$WEBSITE_BUCKET/" --content-type "application/javascript"

echo "✅ Website files uploaded successfully!"
echo "🌍 Website URL: http://$WEBSITE_BUCKET.s3-website-us-east-1.amazonaws.com"