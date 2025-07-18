output "service_name" {
  description = "Name of the kubernetes service"
  value       = kubernetes_service.webapp.metadata[0].name
}

output "app_name" {
  description = "Name of the application"
  value       = var.app_name
}

output "namespace" {
  description = "Namespace where app is deployed"
  value       = var.namespace
}