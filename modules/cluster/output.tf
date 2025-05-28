output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "stable_gke_version" {
  description = "The default STABLE channel GKE version"
  value       = data.google_container_engine_versions.gke_version.release_channel_default_version["STABLE"]
}