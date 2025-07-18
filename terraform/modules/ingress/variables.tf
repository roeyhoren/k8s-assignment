variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "host" {
  description = "Hostname for ingress"
  type        = string
  default     = "localhost"
}

variable "apps" {
  description = "Map of applications to route"
  type = map(object({
    service_name = string
    app_name     = string
    namespace    = string
  }))
  default = {}
}