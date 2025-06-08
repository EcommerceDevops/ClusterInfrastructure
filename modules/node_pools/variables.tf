variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "cluster_name" {
  description = "cluster name"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "stable_gke_version" {
  description = "GKE version to use"
  type        = string
}

variable "pools" {
  description = "Number of node pools for each application tier"
  type        = map(number)

  validation {
    condition = alltrue([
      for k, v in var.pools : v >= 0 && v <= 20
    ])
    error_message = "Each pool size must be between 0 and 20 nodes."
  }

  default = {
    frontend   = 1
    backend    = 4
    database   = 1
    monitoring = 2
  }
}