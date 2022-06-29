locals {
  gke_master_cidr = "10.20.0.0/28"
}

resource "google_container_cluster" "gke_cluster" {
  # we need KMS for etcd encryption
  depends_on = [
    google_kms_key_ring.k8s_key_ring,
    google_compute_firewall.gke_ingress_firewall,
    google_compute_firewall.gke_egress_firewall,
  ]

  project  = var.project_id
  name     = "${var.cluster_name}-cluster"
  location = var.cluster_location

  resource_labels = var.resource_labels

  # kubernetes release channel
  min_master_version = var.k8s_min_version
  release_channel {
    channel = var.k8s_release_channel
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # GKE shielded nodes for kubelet authentication
  enable_shielded_nodes = true

  # enable dataplane v2 (eBPF)
  # this will automatically enable network policies
  # https://cloud.google.com/kubernetes-engine/docs/concepts/dataplane-v2
  datapath_provider = "ADVANCED_DATAPATH"

  # enable workload protection
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # enable google groups authz
  authenticator_groups_config {
    security_group = "gke-security-groups@${var.acl_group_domain}"
  }

  # enable vertical pod autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }

  # use confidential nodes which have memory encryption
  # disabled since it requires the N2D machine type 
  confidential_nodes {
    enabled = false
  }

  node_config {
    # use spot VMs since these are cheaper with the downside of sudden node loss
    preemptible = false
    spot        = var.allow_spot_nodes

    # set the node type
    machine_type = var.node_machine_type
    image_type   = "cos_containerd"

    metadata = {
      disable-legacy-endpoints = true
    }

    # we don't want any Pods to be scheduled on the default node pool
    # sine we're going to remove it anyway
    taint {
      key    = "temp/noschedule"
      value  = "true"
      effect = "NO_EXECUTE"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_node_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
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

  # make this a private GKE cluster
  private_cluster_config {
    # GKE nodes should be private so only LBs can be used to reach services
    enable_private_nodes = true
    # set to true if we only want to allow the private API endpoint
    enable_private_endpoint = false
    # some IP subnet for master nodes
    master_ipv4_cidr_block = local.gke_master_cidr
  }

  # skip the node_config checkov checks since we define it in the GKE nodepool
  # checkov:skip=CKV_GCP_69
  # checkov:skip=CKV_GCP_67

  # TODO: enable Binary Authorization
  # https://github.com/CircleCI-Public/gcp-binary-authorization-orb
  # checkov:skip=CKV_GCP_66
  enable_binary_authorization = false

  # disable basic authentication
  master_auth {
    # use certificate-based authentication 
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # enable a network policy to be set
  network_policy {
    enabled = true
  }

  # allow API auth from anywhere
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
    }
  }

  # use stackdriver GKE for system and workload logs
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  # use stackdriver GKE native system monitoring for everything
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]

    managed_prometheus {
      enabled = true
    }
  }

  # kubernetes addons
  addons_config {
    # accelerate dns caching on nodes locally
    dns_cache_config {
      enabled = true
    }

    # allow auto-creating new Pods
    horizontal_pod_autoscaling {
      disabled = false
    }

    # http load balancing internally
    http_load_balancing {
      disabled = false
    }

    # node_locations
    # cloudrun_config
    # dns_cache_config
    # gce_persistent_disk_csi_driver_config
    # kalm_config
    # config_connector_config
  }

  # when are they allowed to perform upgrades & restarts
  maintenance_policy {
    daily_maintenance_window {
      start_time = "22:00"
    }
  }

  # GKE network setup
  network         = google_compute_network.gke_cluster_vpc.name
  subnetwork      = google_compute_subnetwork.gke_cluster_subnet.name
  networking_mode = "VPC_NATIVE"

  # comment out to enable public access to GKE master API (?)
  # master_authorized_networks_config {}

  # do VPC logging for GKE nodes
  enable_intranode_visibility = true

  # ip allocation subnets
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/24"
  }

  # encrypt etcd data via KMS
  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.k8s_etcd_kms_key.id
  }

  # do not update this resource when this changes
  lifecycle {
    ignore_changes = [node_config, node_pool, initial_node_count]
  }

  timeouts {
    create = "15m"
    update = "30m"
    delete = "30m"
  }
}

# retrieve the numeric gcp project identifier
data "google_project" "project" {}

# make sure our GKE service account has access to KMS for etcd encryption
data "google_iam_policy" "gke_kms" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

    members = [
      "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com",
    ]
  }
}

# the keyring for GKE etcd encryption
resource "google_kms_key_ring_iam_policy" "gke_kms" {
  key_ring_id = google_kms_key_ring.k8s_key_ring.id
  policy_data = data.google_iam_policy.gke_kms.policy_data
}