# Terraform Variables – Expected Values

This document outlines the input variables defined in `variables.tf`, the corresponding values expected in the environment-specific Terraform variable files (`terraform.<environment>.tfvars`), and the purpose of the `.env.<environment>` files in each environment folder.

This folder should contain the following structure in order to the scripts work for provisioning the infrastructure:

.
├── prod.md
├── terraform-cluster.key.prod.json
└── terraform.prod.tfvars

## Environment Variable Files (`.env.<environment>`)

The file .env.stagin should contain the following values:

```
PROJECT_ID=project-id
SA_NAME=terraform-cluster-prod
```

These variables are used by the script `create_sa.sh` to create the service account for each project where the cluster is allocated

## Common Variables Definition (`variables.tf`)

```hcl
variable "project_id" {
  description = "The Google Cloud project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The region where resources will be deployed."
  type        = string
  default     = "us-central1"
}

variable "node_locations" {
  description = "List of zones within the region where node pools will be created."
  type        = list(string)
  default     = ["us-central1-c"]
}

variable "repo_name" {
  description = "Name of the repository or project."
  type        = string
  default     = "name"
}

variable "repo_description" {
  description = "Description for the repository or project."
  type        = string
  default     = "desc"
}

variable "node_pools" {
  description = "Map of node pool names to the number of nodes in each pool."
  type        = map(number)
  default     = { testing = 1 }
}

variable "namespaces" {
  description = "List of Kubernetes namespaces to be created in the cluster."
  type        = list(string)
  default     = ["testing"]
}

variable "credentials_file" {
  description = "Path to the service account credentials JSON file."
  type        = string
  default     = "terraform-key.json"
}

variable "subnet_cidr" {
  description = "CIDR block for the VPC subnet."
  type        = string
}

variable "pods_cidr" {
  description = "CIDR block for the Kubernetes pods network."
  type        = string
}

variable "services_cidr" {
  description = "CIDR block for the Kubernetes services network."
  type        = string
}
```

## Example Minimum `terraform.prod.tfvars`

This example shows the minimal set of variables required for the cluster environments to function properly. Adjust paths and values as necessary for your specific environment.

```hcl
credentials_file = "environments/prod/terraform-cluster-key.prod.json"
project_id       = "your-gcp-project-id"
region           = "us-east4" # Example region
node_locations   = ["us-east4-c"] # Example zone
# Recommended ranges to avoid conflicts between clusters on each environment
subnet_cidr      = "10.100.0.0/20"
pods_cidr        = "10.101.0.0/16"
services_cidr    = "10.102.0.0/20"
node_pools = {
    core = 2
    backend = 4
    database = 1
    monitoring = 1
}

namespaces = [
  "core",
  "backend",
  "database",
  "monitoring"
]
```

## Notes

- The `node_pools` variable defines the names and sizes of node pools; keys are pool names and values are node counts.
- Make sure `project_id` and `region` match your actual Google Cloud project and preferred deployment region.
- The `credentials_file` path should be updated to point to the correct service account JSON key file for each environment. The default value showed here is the path where the `create_sa.sh` script will download the service account key file for every environment
- The CIDR blocks (`subnet_cidr`, `pods_cidr`, and `services_cidr`) must be unique and non-overlapping within your network or different clusters ranges to avoid conflicts.
