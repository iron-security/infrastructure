terraform {
    required_version = ">= v1.0.6"
    
    backend "gcs" {
        bucket = "ironsecurity-terraform-state"
        prefix = "terraform/state"
    }

    required_providers {
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = ">= 3.1.0"
        }

        github = {
            source  = "hashicorp/github"
            version = "= 4.14.0"
        }

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

provider cloudflare {
    email   = var.cf_email
    api_key = var.cf_api_key
    account_id = var.cf_account_id
}

provider github {
    token = var.github_token
    owner = var.github_owner
}

provider google {
    project     = var.gcp_project_id
    region      = var.gcloud_region
}

provider kubernetes {
    cluster_ca_certificate  = module.gcloud.cluster_ca_certificate
    host                    = module.gcloud.cluster_endpoint
    token                   = module.gcloud.cluster_client_token
}