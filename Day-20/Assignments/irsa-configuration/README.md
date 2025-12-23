# IRSA Configuration

This example demonstrates IAM Roles for Service Accounts (IRSA) setup.

## What it does:
- Creates IAM policy for S3 access
- Sets up IAM role with OIDC trust relationship
- Creates service account with role annotation
- Deploys pod that can access S3 using IRSA

## Prerequisites:
- EKS cluster with OIDC provider enabled
- Update the OIDC provider URL in main.tf

## Usage:

```bash
# Update ACCOUNT_ID and OIDC provider in main.tf
terraform init
terraform apply

# Deploy application
kubectl apply -f app.yaml

# Check pod logs
kubectl logs -l app=irsa-demo

# Cleanup
kubectl delete -f app.yaml
terraform destroy
```

## Key Concepts:
- OIDC federation for pod identity
- Service account annotations
- Web identity tokens
- Least privilege access