// our GKE dev cluster with single-zone preemtible nodes 
module "dev_cluster" {
  source = "./gke"

  project_id            = var.project_id
  cluster_name          = "dev"
  cluster_location      = "europe-west1-b"
  cluster_region        = "europe-west1"
  cluster_subnet        = "10.10.0.0/16"
  nat_egress_address_id = google_compute_address.nat_egress_address.id
  gke_min_node_count    = 0
  gke_max_node_count    = 2
}

// our GKE prod cluster with multi-zone/regional preemtible nodes
// our GKE dev cluster with single-zone preemtible nodes 
/*
module "prd_cluster" {
    source = "./gke"

    project_id          = var.project_id
    cluster_name        = "prd"
    cluster_location    = "europe-west1"
    cluster_region      = "europe-west1"
    cluster_subnet      = "10.20.0.0/16"
    nat_egress_address_id = google_compute_address.nat_egress_address.id
    // a regional cluster launches a node per zone anyway, so 3 nodes
    gke_min_node_count  = 1
    // this means 3*3 = 9 nodes
    gke_max_node_count  = 3
}
*/