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
variable "github_org" {
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

# the full email address of the terraform service account
variable "gcp_serviceaccount_email" {
  default = "terraform-ci-cd@ironsecurity.iam.gserviceaccount.com"
}