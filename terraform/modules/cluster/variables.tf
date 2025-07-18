variable "cluster_name" {
  description = "Name of the kind cluster"
  type        = string
  default     = "devops-assignment"
}

variable "node_image" {
  description = "Docker image for kind nodes"
  type        = string
  default     = "kindest/node:v1.27.3"
}