# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = module.cluster.cluster_name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = module.cluster.cluster_endpoint
  description = "GKE Cluster Host"
}
output "reserved_static_ips" {
  description = "List of reserved static IP addresses"
  value       = module.static_external_ip.static_ips
}

output "reserved_static_ip_names" {
  description = "List of names of the reserved static IPs"
  value       = module.static_external_ip.static_ip_names
}
