variable project_id {}

variable k8s_cluster_name {
    default = "cluster-main"
}

variable region {
    default = "europe-west1"
}

variable k8s_release_channel {
  default = "STABLE"
}

variable k8s_min_version {
  default = "latest"   
}

variable gke_min_node_count {
    default = 1
}

variable gke_max_node_count {
    default = 2
}