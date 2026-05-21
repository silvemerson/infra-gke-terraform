resource "google_compute_firewall" "asgard_prod_allow" {
  name    = var.firewall_name
  network = var.network_name

  depends_on = [google_project_service.compute]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
}


