#!/bin/bash

# Build custom AMI with Packer
packer build web-server.json

# Note: After building, you can reference the AMI ID in Terraform
echo "AMI built successfully. Check the output above for the AMI ID."