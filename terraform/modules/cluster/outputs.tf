output "cluster_name" {
  description = "Name of the created cluster"
  value       = var.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = "https://127.0.0.1:6443"
}