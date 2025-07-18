# k8s-assignment

DevOps assignment for setting up local kubernetes cluster with terraform and deploying some web apps.

## What this does

- Sets up a local k8s cluster using kind
- Deploys multiple web applications 
- Each app returns pod name and IP
- Uses ingress for routing traffic

## Structure

```
terraform/
  modules/
    cluster/   - kind cluster setup
    apps/      - web app deployments
    ingress/   - ingress controller
src/
  webapp/    - simple web app code
scripts/     - helper scripts
```

## Requirements

- Docker
- Terraform
- Kind 
- kubectl

## Usage

```bash
# setup cluster
cd terraform
terraform init
terraform apply

# check apps
kubectl get pods
```

## Apps

The web apps return:
- Pod name
- Pod IP 
- Some basic info

## TODO

- [ ] Add more apps
- [ ] Better ingress config
- [ ] CI/CD pipeline
- [ ] Tests