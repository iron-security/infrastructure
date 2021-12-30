resource "google_container_node_pool" "system_preemptible_nodes" {
  name    = "gke-${var.cluster_name}-preempt-nodepool"
  cluster = google_container_cluster.gke_cluster.id

  node_config {
    # use spot VMs since these are cheaper with the downside of sudden node loss
    preemptible = false
    spot        = var.allow_spot_nodes

    # set the node type
    machine_type = var.node_machine_type
    image_type   = "cos_containerd"

    # enable gvisor kernel sandboxing
    sandbox_config {
      sandbox_type = "gvisor"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_node_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/trace.append",
    ]

    # use native Gke metadata server for workload identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }
  }

  # autoscale the nodes within the boundaries
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

# default service account used by the GKE nodes
# these don't have any permissions by default
resource "google_service_account" "gke_node_sa" {
  account_id   = "${var.cluster_name}-node-sa"
  display_name = "Node service account for GKE cluster ${var.cluster_name}"
  project      = var.project_id
}