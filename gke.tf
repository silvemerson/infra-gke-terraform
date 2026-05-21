resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
  location           = var.default_zone
  deletion_protection = false

  depends_on = [google_project_service.container]
  # node_locations           = ["${var.default_region}-a", "${var.default_region}-b"]
  remove_default_node_pool = true
  initial_node_count       = 1
  # network                  = google_compute_network.vpc.id
  # subnetwork               = google_compute_subnetwork.subnet.id

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}
}

## Separately Managed Node Pool
resource "google_container_node_pool" "gke_pool" {
  name           = "${google_container_cluster.gke_cluster.name}-node-pool"
  location       = var.default_region
  cluster        = google_container_cluster.gke_cluster.id
  node_count     = var.node_count
  node_locations = ["${var.default_zone}"]

  autoscaling {
    min_node_count  = var.min_node_count
    max_node_count  = var.max_node_count
    location_policy = "ANY"
  }

  upgrade_settings {
    strategy = "BLUE_GREEN"
  }

  node_config {
    spot         = var.spot_nodes
    machine_type = var.node_size
    disk_size_gb = var.disk_size_gb
  }

  lifecycle {
    ignore_changes = [
      location,
    ]
  }
}
