provider google {
    project     = var.project_id
    region      = var.gcloud_region
}

provider kubernetes {
    alias = "gke_kubernetes"

    cluster_ca_certificate  = module.gcloud.cluster_ca_certificate
    host                    = module.gcloud.cluster_endpoint
    token                   = module.gcloud.cluster_client_token
}

provider helm {
    alias = "gke_helm"

    kubernetes {
        cluster_ca_certificate  = module.gcloud.cluster_ca_certificate
        host                    = module.gcloud.cluster_endpoint
        token                   = module.gcloud.cluster_client_token
    }
}