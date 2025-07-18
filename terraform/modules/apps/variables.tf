variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "image" {
  description = "Docker image for the application"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}

variable "path" {
  description = "URL path for the application"
  type        = string
  default     = "/"
}