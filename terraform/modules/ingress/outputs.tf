output "ingress_name" {
  description = "Name of the ingress resource"
  value       = kubernetes_ingress_v1.main.metadata[0].name
}

output "ingress_host" {
  description = "Host for the ingress"
  value       = var.host
}

output "app_urls" {
  description = "URLs for the applications"
  value = {
    for app_key, app in var.apps : app_key => "http://${var.host}/${app_key}"
  }
}