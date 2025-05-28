
output "static_ips" {
  description = "List of reserved static IP addresses"
  value       = google_compute_address.static_ips[*].address
}

output "static_ip_names" {
  description = "List of names of the reserved static IPs"
  value       = google_compute_address.static_ips[*].name
}
