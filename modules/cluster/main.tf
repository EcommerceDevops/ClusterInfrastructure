# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location       = var.region
  version_prefix = var.gke_version_prefix
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
  node_locations = var.node_locations
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_name
  subnetwork = var.subnet_name

  node_config {
    disk_type    = "pd-standard"
    disk_size_gb = 12 # Must inccremente this value to avoid disk smaller than cluster size selected error.
  }
  
  deletion_protection = false
}