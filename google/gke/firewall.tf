resource "google_compute_firewall" "gke_ingress_firewall" {
  name        = "gke-${var.cluster_name}-ingress-firewall"
  project     = var.project_id
  network     = google_compute_network.gke_cluster_vpc.name
  description = "Main firewall that blocks all ingress traffic."

  priority  = 10
  direction = "INGRESS"

  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

/*
resource "google_compute_firewall" "gke_api_allow" {
  name        = "gke-${var.cluster_name}-allow-firewall"
  project     = var.project_id
  network     = google_compute_network.gke_cluster_vpc.name
  description = "Main firewall that allows traffic to GKE cluster API public endpoint."

  priority  = 9
  direction = "INGRESS"

  allow {
    ports = [443]
    protocol = "tcp"
  }

  destination_ranges = ["${google_container_cluster.gke_cluster.endpoint}/32"]

  source_ranges = ["0.0.0.0/0"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
*/

resource "google_compute_firewall" "gke_egress_firewall" {
  name        = "gke-${var.cluster_name}-egress-firewall"
  project     = var.project_id
  network     = google_compute_network.gke_cluster_vpc.name
  description = "Main firewall that allows specific egress traffic."

  priority  = 10
  direction = "EGRESS"

  allow {
    protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}