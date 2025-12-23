#!/bin/bash

# Deploy Nginx application using kubectl

echo "🚀 Deploying Nginx application..."

# Apply deployment
kubectl apply -f nginx-deployment.yaml

# Apply service
kubectl apply -f nginx-service.yaml

# Wait for deployment to be ready
kubectl wait --for=condition=available --timeout=300s deployment/nginx-demo

# Check status
kubectl get pods -l app=nginx-demo
kubectl get svc nginx-service

echo "✅ Nginx deployment complete!"
echo ""
echo "📊 Application Status:"
kubectl get deployments,pods,services -l app=nginx-demo