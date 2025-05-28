terraform {

  # backend "s3" {
  #   bucket       = "terraform-microservice-state-bucket"
  #   key          = "development/us-west-2/dev/gke/terraform.tfstate"
  #   region       = "us-west-2"
  #   encrypt      = true
  #   use_lockfile = true # Habilita state locking basado en S3
  # }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.29.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }

  required_version = ">= 1.11"
}

