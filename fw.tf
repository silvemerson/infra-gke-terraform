resource "google_compute_firewall" "asgard_prod_allow" {
  name    = "asgard-prod-allow"
  network = "default"
  

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


