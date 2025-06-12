# Terraform Infrastructure - Environments Structure

This repository organizes Terraform configurations into multiple environments to support isolated infrastructure deployments for different stages such as devops, staging, and prod.

## Folder Structure

```

.
├── environments
│   ├── devops
│   │   ├── .env.devops
│   │   ├── terraform.devops.tfvars
│   │   └── terraform-cluster.key.devops.json
│   ├── staging
│   │   ├── .env.staging
│   │   ├── terraform.staging.tfvars
│   │   └── terraform-cluster.key.staging.json
│   └── prod
│       ├── .env.prod
│       ├── terraform.prod.tfvars
│       └── terraform-cluster.key.prod.json

```

## Description

- **environments/devops**: Contains environment-specific files for the development operations environment, including Terraform variable definitions, environment variables, and credentials.
- **environments/staging**: Holds the staging environment files used for pre-production testing, including Terraform variables, environment configs, and credentials.
- **environments/prod**: Contains production environment files with Terraform variables, environment settings, and credentials.

Each environment folder includes:

- `.env.<environment>`: Environment variable file to set up shell variables or configurations needed for the environment.
- `terraform.<environment>.tfvars`: Terraform variable values that customize the infrastructure deployment for the specific environment.
- `terraform-cluster.key.<environment>.json`: Service account key file used for authentication with the cloud provider in that environment.

This structure allows isolated and environment-specific configuration management while sharing Terraform modules and code across environments.
