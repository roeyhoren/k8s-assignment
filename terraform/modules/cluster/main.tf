resource "null_resource" "kind_cluster" {
  triggers = {
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = <<-EOF
      kind create cluster --name ${var.cluster_name} --config ${path.module}/kind-config.yaml
      kubectl cluster-info --context kind-${var.cluster_name}
    EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name ${self.triggers.cluster_name}"
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [null_resource.kind_cluster]
  
  provisioner "local-exec" {
    command = <<-EOF
      kubectl wait --for=condition=ready nodes --all --timeout=300s --context kind-${var.cluster_name}
      kubectl get nodes --context kind-${var.cluster_name}
    EOF
  }
}