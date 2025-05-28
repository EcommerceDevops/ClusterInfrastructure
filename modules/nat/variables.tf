variable "project_id" {
  description = "ID del proyecto de Google Cloud"
  type        = string
}

variable "region" {
  description = "Región donde se desplegará el clúster y el NAT"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "Nombre de la VPC en la que corre el clúster"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Nombre base del clúster GKE"
  type        = string
  default     = "gke-private"
}