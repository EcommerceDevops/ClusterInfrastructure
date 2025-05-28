variable "namespaces" {
  description = "List of Kubernetes namespaces to create"
  type        = list(string)
  default     = ["frontend", "backend", "database", "monitoring"]
}