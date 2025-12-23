#!/bin/bash

# Cleanup Nginx application

echo "🧹 Cleaning up Nginx application..."

# Delete service
kubectl delete -f nginx-service.yaml --ignore-not-found=true

# Delete deployment
kubectl delete -f nginx-deployment.yaml --ignore-not-found=true

# Wait for resources to be deleted
kubectl wait --for=delete --timeout=60s deployment/nginx-demo || true

echo "✅ Cleanup complete!"