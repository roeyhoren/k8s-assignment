#!/bin/bash
set -e

echo "Cleaning up K8s Assignment..."

# Destroy terraform resources
echo "Destroying infrastructure..."
cd terraform
terraform destroy -auto-approve

# Delete kind cluster
echo "Deleting kind cluster..."
kind delete cluster --name devops-assignment

echo "Cleanup complete!"