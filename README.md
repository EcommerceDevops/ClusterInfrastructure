# Cluster Infrastructure with Terraform

This repository defines the infrastructure for a Kubernetes cluster using Terraform. It supports multiple environments (`devops`, `staging`, `prod`) and is modularized for reusability and scalability.

## 📁 Project Structure

```bash
.
├── environments
│   ├── devops
│   │   ├── .env.devops
│   │   ├── devops.md
│   │   ├── terraform-cluster.key.devops.json
│   │   └── terraform.devops.tfvars
│   ├── ENVS.md
│   ├── prod
│   │   ├── .env.prod
│   │   ├── prod.md
│   │   ├── terraform-cluster.key.prod.json
│   │   └── terraform.prod.tfvars
│   └── staging
│       ├── .env.staging
│       ├── staging.md
│       ├── terraform-cluster.key.staging.json
│       └── terraform.staging.tfvars
├── main.tf
├── modules
│   ├── cluster
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── namespaces
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── networking
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── node_pools
│       ├── main.tf
│       └── variables.tf
├── outputs.tf
├── README.md
├── scripts
│   ├── apply_terraform.sh
│   ├── create_sa.sh
│   └── destroy_terraform.sh
├── variables.tf
└── versions.tf
```

## 🧩 Modules

- **cluster**: Manages the Kubernetes cluster creation.
- **networking**: Sets up networking resources such as VPCs, subnets, etc.
- **node_pools**: Defines node pool configurations for the cluster.
- **namespaces**: Creates Kubernetes namespaces.

## 🌍 Environments

Each environment (`devops`, `staging`, `prod`) includes:

- `.env.$ENV`: Environment variables for scripts use
- `terraform.$ENV,tfvars`: Terraform sensitive vars for environment

## ⚙️ Scripts

- `apply_terraform.sh`: Initializes and applies Terraform configurations.
- `destroy_terraform.sh`: Destroys all provisioned resources in a defined order to avoid dependency problems.
- `create_sa.sh`: Creates service accounts or other initial setup tasks.

## 🚀 Usage

The scripts configure the terraform workspace defined for each environment to avoid state problems, and provision the infrastructure using the correct tfvars file and cloud provider keys.

The provided scripts for automation requires the environment to configure through params. The accepted values are `devops`, `prod`, `staging`.

For example:

```bash
./scripts/apply_terraform.sh devops
./scripts/destroy_terraform.sh prod
```

It is necessary to export the following variables in order to access the s3 backend where the infrastructe state will be saved:

```bash
AWS_ACCESS_KEY_ID="secret-access-key"
AWS_SECRET_ACCESS_KEY="secret-access-key-id"
AWS_REGION="us-east-1"
```

For the service account creation, is necessary to be logged in on the gcloud cli as an admin user on the project where the service account is being configured.

## 🛠 Requirements

- [Terraform](https://www.terraform.io/) >= 1.11
- Proper credentials set up for infrastructure provisioning. For further information about the environments variables structure, see [env guide](environments/ENVS.md)
