resource "google_compute_address" "static_ips" {
  count        = var.ip_count
  name         = "${var.name_prefix}-${count.index}"
  region       = var.region
  address_type = "EXTERNAL"
  project      = var.project_id
}





