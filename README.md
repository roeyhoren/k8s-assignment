# k8s-assignment

DevOps assignment for setting up local kubernetes cluster with terraform and deploying multiple web apps.

## What this does

- Sets up a local k8s cluster using kind
- Deploys 3 web applications with minimal code duplication
- Each app returns pod name and IP address
- Uses nginx ingress for routing traffic to different apps
- Includes CI/CD pipeline with GitHub Actions

## Structure

```
terraform/
  modules/
    cluster/   - kind cluster setup
    apps/      - reusable web app deployment module
    ingress/   - ingress controller and routing
src/
  webapp/    - simple go web app code
scripts/     - helper scripts for deploy/test/cleanup
```

## Requirements

- Docker
- Terraform
- Kind 
- kubectl

## Quick Start

```bash
# Easy deployment
./scripts/deploy.sh

# Or manual deployment
cd terraform
terraform init
terraform apply

# Test the apps
./scripts/test.sh

# Cleanup when done
./scripts/cleanup.sh
```

## Applications

The web apps are available at:
- http://localhost/app1
- http://localhost/app2  
- http://localhost/app3

Each endpoint returns JSON with:
- Pod name
- Pod IP address
- App name
- Welcome message

## Features

- ✅ Modular terraform structure
- ✅ Minimal code duplication (reusable app module)
- ✅ Health checks and readiness probes
- ✅ Ingress routing with distinct paths
- ✅ CI/CD pipeline with GitHub Actions
- ✅ Helper scripts for easy deployment

## Bonus Features

- Multiple applications using the same reusable module
- Automated testing in CI/CD pipeline
- Local development scripts