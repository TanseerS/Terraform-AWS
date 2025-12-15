#!/bin/bash

# Package Apps Script for Blue-Green Deployment Demo
# This script packages both versions of the application for deployment

echo "Packaging applications for Blue-Green Deployment Demo..."

# Create app-v1 zip
echo "Creating app-v1.zip..."
cd app-v1
zip -r ../app-v1.zip . -x "*.git*" "*.DS_Store"
cd ..

# Create app-v2 zip
echo "Creating app-v2.zip..."
cd app-v2
zip -r ../app-v2.zip . -x "*.git*" "*.DS_Store"
cd ..

echo "Packaging complete!"
echo "Created files:"
echo "  - app-v1.zip (Version 1.0 - Blue Environment)"
echo "  - app-v2.zip (Version 2.0 - Green Environment)"
echo ""
echo "You can now run 'terraform apply' to deploy the infrastructure."