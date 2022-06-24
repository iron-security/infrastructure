# VPC
resource "google_compute_network" "gke_cluster_vpc" {
  project                 = var.project_id
  name                    = "gke-${var.cluster_name}-vpc"
  auto_create_subnetworks = false
  #delete_default_routes_on_create = true
}

# Subnet
resource "google_compute_subnetwork" "gke_cluster_subnet" {
  project                  = var.project_id
  name                     = "gke-${var.cluster_name}-subnet"
  region                   = var.cluster_region
  network                  = google_compute_network.gke_cluster_vpc.name
  ip_cidr_range            = var.cluster_subnet
  private_ip_google_access = false

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_global_address" "k8s_vpc_private_ips" {
  project = var.project_id

  name          = "gke-${var.cluster_name}-private-vpc-ips"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.gke_cluster_vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.gke_cluster_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.k8s_vpc_private_ips.name]
}

resource "google_compute_route" "egress_internet" {
  project          = var.project_id
  name             = "gke-${var.cluster_name}-route-egress-internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.gke_cluster_vpc.name
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_router" "gke_vpc_router" {
  project = var.project_id
  depends_on = [ google_compute_subnetwork.gke_cluster_subnet ]
  name    = "gke-${var.cluster_name}-router"
  region  = google_compute_subnetwork.gke_cluster_subnet.region
  network = google_compute_network.gke_cluster_vpc.name
}

resource "google_compute_router_nat" "nat_router" {
  project = var.project_id
  depends_on = [ google_compute_router.gke_vpc_router ]

  name                   = "${google_compute_subnetwork.gke_cluster_subnet.name}-nat-router"
  router                 = google_compute_router.gke_vpc_router.name
  region                 = google_compute_router.gke_vpc_router.region
  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [
    var.nat_egress_address_id,
  ]

  # only the gke nodes should be able to NAT to egress
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.gke_cluster_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}