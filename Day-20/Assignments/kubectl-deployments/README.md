# kubectl Application Deployments

This example demonstrates basic application deployment using kubectl.

## What it does:
- Deploys Nginx with 2 replicas
- Creates a ClusterIP service
- Shows kubectl commands for deployment management

## Usage:

```bash
# Deploy application
./deploy.sh

# Check status
kubectl get pods -l app=nginx-demo
kubectl get svc nginx-service

# Test application (port forward)
kubectl port-forward svc/nginx-service 8080:80
# Visit http://localhost:8080

# Cleanup
./cleanup.sh
```

## Key Concepts:
- Kubernetes Deployments for stateless applications
- Services for internal networking
- kubectl apply/delete for resource management
- Labels and selectors for resource grouping