resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = <<-EOF
      kind create cluster --name ${var.cluster_name} --config ${path.module}/kind-config.yaml
    EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name ${var.cluster_name}"
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [null_resource.kind_cluster]
  
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=ready nodes --all --timeout=300s"
  }
}