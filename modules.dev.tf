provider "kubernetes" {
  alias = "dev"

  cluster_ca_certificate = module.google.dev_cluster_ca_certificate
  host                   = module.google.dev_cluster_endpoint
  token                  = data.google_client_config.provider.access_token
}

provider "helm" {
  alias = "dev"

  kubernetes {
    cluster_ca_certificate = module.google.dev_cluster_ca_certificate
    host                   = module.google.dev_cluster_endpoint
    token                  = data.google_client_config.provider.access_token
  }
}

#
# ---
#

module "kubernetes" {
  depends_on = [
    module.google,
    module.google.dev_cluster_endpoint
  ]

  source = "./kubernetes"

  providers = {
    kubernetes = kubernetes.dev
  }

  terraform_sa_email = var.gcp_serviceaccount_email
  project_id         = var.gcp_project_id
}

module "helm_dev" {
  depends_on = [
    module.google,
    module.kubernetes,
  ]

  source = "./helm/dev"

  providers = {
    kubernetes = kubernetes.dev
    helm       = helm.dev
  }

  github_token = var.github_token
}
