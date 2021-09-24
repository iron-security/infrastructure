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


module "kubernetes" {
  source = "./kubernetes"
  
  depends_on = [ module.google ]
}

module "helm" {
  source = "./helm"

  depends_on = [ module.kubernetes ]
}