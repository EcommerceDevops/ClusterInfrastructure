resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Recurso para la subred
resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  network                  = google_compute_network.vpc.id
  project                  = var.project_id
  region                   = var.region
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true // ¡Crucial! Permite el acceso a APIs de Google

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

# 1. Reservar una IP externa estática para el NAT
resource "google_compute_address" "nat_ip" {
  name         = "${var.network_name}-nat-ip"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Static external IP for Cloud NAT"
}

# 2. Crear un Cloud Router (requisito para Cloud NAT)
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  network = google_compute_network.vpc.id
  project = var.project_id
  region  = var.region
}

# 3. Crear y configurar el Cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat-gateway"
  router                             = google_compute_router.router.name
  project                            = var.project_id
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_ip.self_link]

  # Especifica a qué subred se aplicará el NAT
  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}