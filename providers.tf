terraform {
  required_version = ">= v1.2.3"

  backend "gcs" {
    bucket = "ironsecurity-terraform-state"
    prefix = "terraform/state"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.17.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 4.26.0"
    }

    # TODO: remove google-beta in favour of google when they merge 'google_project_service_identity' and 'logging_config' in GKE
    # this will need to be removed from every providers.tf file
    google = {
      source  = "hashicorp/google-beta"
      version = ">= 4.26.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

provider "cloudflare" {
  email      = var.cf_email
  api_key    = var.cf_api_key
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcloud_region
}

data "google_client_config" "provider" {}
