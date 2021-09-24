module "cloudflare" {
  source = "./cloudflare"

  account_admin = var.cf_email
}

module "github" {
  source = "./github"
}

module "google" {
  source = "./google"

  project_id = var.gcp_project_id
}
/*
module "kubernetes" {
  source = "./kubernetes"
  
  depends_on = [ module.google ]
  
  count = var.skip_kubernetes_deploy == true ? 0 : 1
}

module "helm" {
  source = "./helm"

  depends_on = [ module.google, module.kubernetes ]

  count = var.skip_kubernetes_deploy == true ? 0 : 1
}
*/