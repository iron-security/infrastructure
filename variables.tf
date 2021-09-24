# cloudflare email
variable "cf_email" {}

# cloudflare api key
variable "cf_api_key" {}

# cloudflare account id
variable "cf_account_id" {
  default = "cc3c0a0320f6300a87a710edf2731e79"
}

# github API token
variable "github_token" {}

# github org/owner slug
variable "github_owner" {
  default = "iron-security"
}

# google cloud project id
variable "gcp_project_id" {
  default = "ironsecurity"
}

# google cloud (default) region
variable "gcloud_region" {
  default = "europe-west1"
}

# this indicates that we skip the helm/kubernetes providers and only run the google one
# this fixes a nasty limitation of Terraform where you can't plan/apply on things that are
# not known yet, like the kubernetes cluster credentials/hostname, resulting
# in errors like "Error: Get "http://localhost/api/v1/namespaces": dial tcp [::1]:80: connect: connection refused"
variable "skip_kubernetes_deploy" {
  default = false
}