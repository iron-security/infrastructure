resource "google_container_cluster" "main_cluster" {
  # we need KMS for etcd encryption
  depends_on = [
    google_kms_key_ring.k8s_key_ring,
  ]

  project  = var.project_id
  name     = var.cluster_name
  location = var.cluster_location

  resource_labels = {
    cluster = "main"
    stage   = "prd"
  }

  # kubernetes release channel
  min_master_version = var.k8s_min_version
  release_channel {
    channel = var.k8s_release_channel
  }

  # make sure we use our custom node pool
  initial_node_count       = 1
  remove_default_node_pool = true

  # to comply with our shielded VM policy in the temporary GKE nodepool setup during start
  # we need to supply the node_config here with shielded_instance_config
  node_config {
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }
  }

  # GKE shielded nodes for kubelet authentication
  enable_shielded_nodes = true

  # enable dataplane v2 (eBPF)
  # this will automatically enable network policies
  # https://cloud.google.com/kubernetes-engine/docs/concepts/dataplane-v2
  datapath_provider = "ADVANCED_DATAPATH"

  # enable workload protection
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  # enable google groups authz
  authenticator_groups_config {
    security_group = "gke-security-groups@${var.acl_group_domain}"
  }

  # enable vertical pod autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }

  # make this a private GKE cluster
  private_cluster_config {
    # GKE nodes should be private so only LBs can be used to reach services
    enable_private_nodes = true
    # we still want to reach the GKE API server for kubectl
    enable_private_endpoint = false
    # some IP subnet for master nodes
    master_ipv4_cidr_block = "10.20.0.0/28"
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
    # disable basic auth for security reasons
    username = ""
    password = ""

    # but allow certificate-based authentication
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  # allow API auth from anywhere
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
    }
  }

  # use stackdriver GKE for system and workload logs
  logging_service = "logging.googleapis.com/kubernetes"
  /*logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }*/

  # use stackdriver GKE for system monitoring
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  /*monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }*/

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

    # enable istio service mesh
    /*
    istio_config {
      disabled = var.enable_istio == true ? false : true
      auth     = "AUTH_MUTUAL_TLS"
    }
    */

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
}

resource "google_service_account" "node_default" {
  account_id   = "gke-${var.cluster_name}-node-default-sa"
  display_name = "Default serviceaccount for GKE nodes."
}

resource "google_service_account_key" "node_default_key" {
  service_account_id = google_service_account.node_default.name
}

resource "google_project_service_identity" "gke_sa" {
  project = var.project_id
  service = "container.googleapis.com"
}

# make sure our GKE service account has access to KMS for etcd encryption
data "google_iam_policy" "gke_kms" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

    members = [
      "serviceAccount:${google_project_service_identity.gke_sa.email}",
    ]
  }
}

# the keyring for GKE etcd encryption
resource "google_kms_key_ring_iam_policy" "gke_kms" {
  key_ring_id = google_kms_key_ring.k8s_key_ring.id
  policy_data = data.google_iam_policy.gke_kms.policy_data
}