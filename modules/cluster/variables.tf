variable "project_id" {
  description = "project id"
  type        = string
}

variable "name" {
  type = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "node_locations" {
  description = "node locations"
  type        = list(string)
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "subnet_name" {
  description = "subnet name"
  type        = string
}

variable "network_id" {
  description = "network id"
  type        = string
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}

variable "pods_range_name" {
  description = "Pods secondary range name"
  type        = string
}

variable "services_range_name" {
  description = "Services secondary range name"
  type        = string
}

variable "gke_version_prefix" {
  description = "Prefix for GKE version"
  type        = string
  default     = "1.32."
}