variable "project_id" {
  description = "project id"
  type        = string
}

variable "region" {
  description = "region"
  default     = "us-central1"
  type        = string
}

variable "node_locations" {
  description = "node locations"
  default     = ["us-central1-c"]
  type        = list(string)
}

variable "repo_name" {
  description = "repo_name"
  default     = "name"
  type        = string
}

variable "repo_description" {
  description = "repo_description"
  default     = "desc"
  type        = string
}

variable "node_pools" {
  description = "node pools"
  default     = { testing = 1 }
  type        = map(number)
}

variable "namespaces" {
  description = "namespaces"
  default     = ["testing"]
  type        = list(string)
}

variable "credentials_file" {
  description = "value of the credentials file"
  type        = string
  default     = "terraform-key.json"
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
  type        = string
}

variable "pods_cidr" {
  description = "Pods CIDR range"
  type        = string
}

variable "services_cidr" {
  description = "Services CIDR range"
  type        = string
}





