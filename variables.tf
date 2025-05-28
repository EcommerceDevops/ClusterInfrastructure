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

variable "credentials_file" {
  description = "value of the credentials file"
  type        = string
  default     = "terraform-key.json"
}
