# gcloud project id
variable "project_id" {}

# name of the gke cluster being created
variable "cluster_name" {}

# if this is a region, it sets up a multi-zone cluster (1 master + 1 node per zone, e.g. 3 per region)
# if a zone, a single one is created e.g. for dev
variable "cluster_location" {}

# the GKE VPC region, since this cannot be a zone
variable "cluster_region" {}

# vpc subnet to assign to the cluster network in CIDR
variable "cluster_subnet" {}

# id of the compute_address to run the cluster in
variable "nat_egress_address_id" {}

# release channel of kubernetes
variable "k8s_release_channel" {
  default = "STABLE"
}

# minimum version of kubernetes to require
# see https://docs.bridgecrew.io/docs/ensure-legacy-compute-engine-instance-metadata-apis-are-disabled
variable "k8s_min_version" {
  default = "1.12"
}

# minimum amount of nodes to run
variable "gke_min_node_count" {
  default = 0
}

# maximum amount of nodes to run
variable "gke_max_node_count" {
  default = 3
}

# machine type for the kubernetes worker nodes
variable "node_machine_type" {
  default = "e2-micro"
}