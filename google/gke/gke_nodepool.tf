resource "google_container_node_pool" "main_preemptible_nodes" {
  name       = "gke-${var.cluster_name}-preempt-nodepool"
  cluster    = google_container_cluster.main_cluster.id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.node_machine_type
    image_type   = "COS"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.node_default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }
  }

  autoscaling {
    min_node_count = var.gke_min_node_count
    max_node_count = var.gke_max_node_count
  }

  # gke can perform auto-maintenance on nodes
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  # only upgrade nodes 1 at a time
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 1
  }
}