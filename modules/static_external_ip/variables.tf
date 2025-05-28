variable "project_id" {
  description = "ID of the GCP project where IPs will be created"
  type        = string
}

variable "region" {
  description = "Region where the IP addresses will be reserved"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for the name of each static IP"
  type        = string
}

variable "ip_count" {
  description = "Number of static IPs to create"
  type        = number
  default     = 1
}