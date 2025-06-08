terraform {

  backend "s3" {
    bucket       = "terraform-ecommerce-state-bucket"
    key          = "ecommerce/gke/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.37.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }

  required_version = ">= 1.11"
}

