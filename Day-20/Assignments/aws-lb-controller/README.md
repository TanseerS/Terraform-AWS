# AWS Load Balancer Controller

This example demonstrates setting up AWS Load Balancer Controller for ingress management.

## What it does:
- Creates IAM role and policy for ALB controller
- Deploys ALB controller to EKS cluster
- Sets up ingress class for ALB
- Creates sample ingress using ALB

## Prerequisites:
- EKS cluster with OIDC provider
- Update OIDC provider ID in main.tf
- Update ACCOUNT_ID and CLUSTER_NAME in controller.yaml

## Usage:

```bash
# Setup IAM
terraform init
terraform apply

# Deploy controller (update ACCOUNT_ID and CLUSTER_NAME first)
kubectl apply -f controller.yaml

# Deploy sample app first (from kubectl-deployments)
cd ../kubectl-deployments
./deploy.sh

# Deploy ingress
kubectl apply -f sample-ingress.yaml

# Get ALB URL
kubectl get ingress nginx-ingress

# Cleanup
kubectl delete -f sample-ingress.yaml
kubectl delete -f controller.yaml
terraform destroy
```

## Key Concepts:
- ALB ingress controller for Kubernetes
- IAM roles for service accounts (IRSA)
- Ingress resources with AWS annotations
- Load balancer provisioning