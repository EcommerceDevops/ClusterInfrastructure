# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  for_each = var.pools
  name     = "${each.key}-pool"
  location = var.region
  cluster  = var.cluster_name

  version    = var.stable_gke_version
  node_count = each.value

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
      role = each.key
    }

    preemptible  = false
    disk_size_gb = 10
    disk_type    = "pd-ssd"
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke", "gke-${each.key}-pool"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
