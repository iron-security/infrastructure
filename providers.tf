terraform {
  required_version = ">= v1.0.7"

  backend "gcs" {
    bucket = "ironsecurity-terraform-state"
    prefix = "terraform/state"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.1.0"
    }

    github = {
      source  = "hashicorp/github"
      version = ">= 4.15.1"
    }

    # TODO: remove google-beta in favour of google when they merge 'google_project_service_identity'
    # this will need to be removed from every providers.tf file
    google = {
      source  = "hashicorp/google-beta"
      version = ">= 3.84.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.3.0"
    }
  }
}

provider "cloudflare" {
  email      = var.cf_email
  api_key    = var.cf_api_key
  account_id = var.cf_account_id
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcloud_region
}

provider "kubernetes" {
  cluster_ca_certificate = module.google.cluster_ca_certificate
  host                   = module.google.cluster_endpoint
  client_certificate     = module.google.cluster_client_certificate
  client_key             = module.google.cluster_client_key
}

provider "helm" {}