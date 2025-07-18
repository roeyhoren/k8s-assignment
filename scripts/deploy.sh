#!/bin/bash
set -e

echo "Deploying K8s Assignment..."

# Check if required tools are installed
echo "Checking prerequisites..."
command -v docker >/dev/null 2>&1 || { echo "Docker is required but not installed."; exit 1; }
command -v kind >/dev/null 2>&1 || { echo "Kind is required but not installed."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl is required but not installed."; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "Terraform is required but not installed."; exit 1; }

echo "✓ All prerequisites are installed"

# Deploy with terraform
echo "Deploying infrastructure..."
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

echo ""
echo "Deployment complete!"
echo ""
echo "Applications are available at:"
echo "- http://localhost/app1"
echo "- http://localhost/app2"
echo "- http://localhost/app3"
echo ""
echo "Run '../scripts/test.sh' to test the applications"