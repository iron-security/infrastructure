module "cloudflare" {
  source = "./cloudflare"

  account_admin = var.cf_email
}

#
# ---
#

module "github" {
  depends_on = [module.cloudflare]

  source = "./github"
}

#
# ---
#

module "google" {
  depends_on = [module.github]

  source = "./google"

  project_id = var.gcp_project_id
}
