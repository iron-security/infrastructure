resource "google_compute_address" "nat_egress_address" {
  project = var.project_id
  region  = "europe-west1"

  name = "nat-egress-address"

  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}