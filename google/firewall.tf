resource "google_compute_firewall" "gke_ingress_firewall" {
  name    = "main-ingress-firewall"
  network = google_compute_network.gke_cluster_vpc.name
  description = "Main firewall that blocks all ingress traffic."
  
  direction = "INGRESS"
  
  # allow {}

  deny {
      protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "gke_egress_firewall" {
  name    = "main-egress-firewall"
  network = google_compute_network.gke_cluster_vpc.name
  description = "Main firewall that allows specific egress traffic."
  
  direction = "EGRESS"
  allow {
      protocol = "all"
  }

  # deny {}

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}