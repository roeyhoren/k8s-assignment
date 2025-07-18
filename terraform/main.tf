# Note: We'll use kubectl apply instead of the kubernetes provider
# to avoid provider initialization issues

# Create the cluster
module "cluster" {
  source = "./modules/cluster"
  
  cluster_name = var.cluster_name
}


# Build the webapp image
resource "null_resource" "build_webapp_image" {
  depends_on = [module.cluster]
  
  provisioner "local-exec" {
    command = <<-EOF
      docker build -t webapp:latest ../src/webapp/
      kind load docker-image webapp:latest --name ${var.cluster_name}
    EOF
  }
}

# Wait for kubernetes API to be ready
resource "null_resource" "wait_for_k8s_api" {
  depends_on = [module.cluster]
  
  provisioner "local-exec" {
    command = <<-EOF
      # Double-check that the cluster is accessible
      echo "Verifying Kubernetes API access..."
      kubectl get nodes --context kind-${var.cluster_name}
      echo "Kubernetes API is ready"
    EOF
  }
}

# Deploy applications using kubectl
resource "null_resource" "deploy_apps" {
  depends_on = [null_resource.build_webapp_image, null_resource.wait_for_k8s_api]
  
  provisioner "local-exec" {
    command = <<-EOF
      # Deploy ingress controller first
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-${var.cluster_name}
      
      # Wait for ingress controller to be ready
      kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s --context kind-${var.cluster_name}
      
      # Deploy applications
      kubectl apply -f k8s-manifests.yaml --context kind-${var.cluster_name}
      
      # Give pods time to start
      sleep 15
      
      # Check pod status
      echo "Checking pod status..."
      kubectl get pods --context kind-${var.cluster_name} -o wide
      
      # Check if any pods are failing
      kubectl describe pods --context kind-${var.cluster_name} | grep -A 10 -B 5 "Warning\|Error" || true
      
      # Wait for applications to be ready with longer timeout
      echo "Waiting for app1 pods..."
      kubectl wait --for=condition=ready pod -l app=app1 --timeout=180s --context kind-${var.cluster_name} || {
        echo "App1 pods failed to become ready, checking logs..."
        kubectl logs -l app=app1 --context kind-${var.cluster_name} --tail=50 || true
        exit 1
      }
      
      echo "Waiting for app2 pods..."
      kubectl wait --for=condition=ready pod -l app=app2 --timeout=180s --context kind-${var.cluster_name} || {
        echo "App2 pods failed to become ready, checking logs..."
        kubectl logs -l app=app2 --context kind-${var.cluster_name} --tail=50 || true
        exit 1
      }
      
      echo "Waiting for podinfo pods..."
      kubectl wait --for=condition=ready pod -l app=podinfo --timeout=180s --context kind-${var.cluster_name} || {
        echo "Podinfo pods failed to become ready, checking logs..."
        kubectl logs -l app=podinfo --context kind-${var.cluster_name} --tail=50 || true
        exit 1
      }
      
      echo "All applications are ready!"
    EOF
  }
}