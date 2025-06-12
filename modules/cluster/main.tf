# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location       = var.region
  version_prefix = var.gke_version_prefix
}

resource "google_container_cluster" "primary" {
  name                     = var.name
  location                 = var.region
  node_locations           = var.node_locations
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.vpc_name
  subnetwork               = var.subnet_name

  # Stablishing the GKE version to avoid issues with the cluster version
  min_master_version = data.google_container_engine_versions.gke_version.latest_master_version

  # 
  release_channel {
    channel = "UNSPECIFIED"
  }

  private_cluster_config {
    enable_private_nodes    = true            // Nodos solo con IP interna
    enable_private_endpoint = false           // Endpoint del máster sigue público para kubectl
    master_ipv4_cidr_block  = "172.16.0.0/28" // Rango privado para el máster
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  node_config {
    disk_type    = "pd-standard"
    disk_size_gb = 20 # Must inccremente this value to avoid disk smaller than cluster size selected error.
  }

  deletion_protection = false
}