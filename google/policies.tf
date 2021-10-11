// enforce locations in belgium
resource "google_project_organization_policy" "enforce_eu" {
  project    = var.project_id
  constraint = "constraints/gcp.resourceLocations"
  list_policy {
    allow {
      values = [
        "eu-locations",
      ]
    }
  }
}

// do not allow public cloud storage buckets
resource "google_project_organization_policy" "disallow_public_buckets" {
  project    = var.project_id
  constraint = "constraints/storage.publicAccessPrevention"
  boolean_policy {
    enforced = true
  }
}

// do not assign default permissions to default service accounts
resource "google_project_organization_policy" "disable_automatic_sa_iam" {
  project    = var.project_id
  constraint = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
  boolean_policy {
    enforced = true
  }
}

// do not use IPv6 internally
resource "google_project_organization_policy" "disable_ipv6" {
  project    = var.project_id
  constraint = "constraints/compute.disableAllIpv6"
  boolean_policy {
    enforced = true
  }
}

// disallow public IPv6 usage
resource "google_project_organization_policy" "disallow_public_ipv6" {
  project    = var.project_id
  constraint = "constraints/compute.disableVpcExternalIpv6"
  boolean_policy {
    enforced = true
  }
}

// disallow public IPv6 usage
resource "google_project_organization_policy" "disallow_vpcinternal_ipv6" {
  project    = var.project_id
  constraint = "constraints/compute.disableVpcInternalIpv6"
  boolean_policy {
    enforced = true
  }
}

// disallow cross-project service accounts
resource "google_project_organization_policy" "disable_crossproject_sa" {
  project    = var.project_id
  constraint = "constraints/iam.disableCrossProjectServiceAccountUsage"
  boolean_policy {
    enforced = true
  }
}

// disable guest compute engine metadata
resource "google_project_organization_policy" "disable_guest_metadata" {
  project    = var.project_id
  constraint = "constraints/compute.disableGuestAttributesAccess"
  boolean_policy {
    enforced = true
  }
}

// disable vm serial port access
resource "google_project_organization_policy" "disable_vm_serial_port" {
  project    = var.project_id
  constraint = "constraints/compute.disableSerialPortAccess"
  boolean_policy {
    enforced = true
  }
}

// disable the default network creation
resource "google_project_organization_policy" "disable_default_network" {
  project    = var.project_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"
  boolean_policy {
    enforced = true
  }
}

// enforce uniform bucket-level access for cloud storage
resource "google_project_organization_policy" "enforce_bucket_uniform_access" {
  project    = var.project_id
  constraint = "constraints/storage.uniformBucketLevelAccess"
  boolean_policy {
    enforced = true
  }
}

// enforce compute engine OS login
resource "google_project_organization_policy" "enforce_compute_oslogin" {
  project    = var.project_id
  constraint = "constraints/compute.requireOsLogin"
  boolean_policy {
    enforced = true
  }
}

// disallow public IP access to Cloud SQL
resource "google_project_organization_policy" "disallow_cloudsql_public_ip_access" {
  project    = var.project_id
  constraint = "constraints/sql.restrictPublicIp"
  boolean_policy {
    enforced = true
  }
}

// enforce the use of shielded VMs
resource "google_project_organization_policy" "enforce_shielded_vms" {
  project    = var.project_id
  constraint = "constraints/compute.requireShieldedVm"
  boolean_policy {
    enforced = true
  }
}

// disable uploading keys to service accounts
resource "google_project_organization_policy" "disable_publickey_sa" {
  project    = var.project_id
  constraint = "constraints/iam.disableServiceAccountKeyUpload"
  boolean_policy {
    enforced = true
  }
}

// disallow external IPs for VMs
resource "google_project_organization_policy" "disable_vm_public_ips" {
  project    = var.project_id
  constraint = "constraints/compute.vmExternalIpAccess"
  list_policy {
    deny {
      all = true
    }
  }
}

// disallow adding other domains to the IAM policies
resource "google_project_organization_policy" "disallow_iam_external_domains" {
  project    = var.project_id
  constraint = "constraints/iam.allowedPolicyMemberDomains"
  boolean_policy {
    enforced = true
  }
}