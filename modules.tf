module "cloudflare" {
    source = "./cloudflare"

    account_admin = var.cf_email
}

module "github" {
    source = "./github"    
}