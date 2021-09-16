terraform {
    required_version = ">= v0.15"
    
    backend "gcs" {
        bucket = "terraform-gcloud-state"
        prefix = "terraform/state"
    }

    required_providers {
      google = {
          version = ">= 3.65.0"
      }

      kubernetes = {
          version = ">= 2.0.3"
      }

      helm = {
          version = ">= 2.0.3"
      }
    }
}