output "cluster_name" {
  description = "Name of the created cluster"
  value       = module.cluster.cluster_name
}

output "app_urls" {
  description = "URLs for accessing the applications"
  value = {
    app1 = "http://localhost/app1"
    app2 = "http://localhost/app2"
    app3 = "http://localhost/app3"
  }
}

output "ingress_host" {
  description = "Ingress host"
  value       = "localhost"
}

output "instructions" {
  description = "Instructions for accessing the applications"
  value = <<-EOF
    Applications are available at:
    - http://localhost/app1
    - http://localhost/app2
    - http://localhost/app3
    
    Each endpoint returns pod information including name and IP.
  EOF
}