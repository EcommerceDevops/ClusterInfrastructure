resource "google_compute_router" "nat_router" {
  name    = "gke-${var.cluster_name}-router"
  region  = var.region
  network = var.network
}

resource "google_compute_router_nat" "nat" {
  name   = "gke-${var.cluster_name}-nat"
  region = var.region
  router = google_compute_router.nat_router.name

  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_endpoint_independent_mapping = true
}    