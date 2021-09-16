# this is only used internally within the gcloud module
module gcloud {
    source = "./modules/gcloud/"

    region     = var.gcloud_region
    project_id = var.project_id

    providers = {}
}

# this is enriched by the gcloud module and used by other modules
module kubernetes {
    source = "./modules/kubernetes"
    depends_on = [ module.gcloud ]

    providers = {
        kubernetes = kubernetes.gke_kubernetes
    }
}

module helm {
    source = "./modules/helm"
    depends_on = [ module.kubernetes, module.gcloud ]

    project_id = var.project_id
    externalIP = module.gcloud.ingress_lb_address

    providers = {
        kubernetes = kubernetes.gke_kubernetes
        helm = helm.gke_helm
    }
}
