resource "google_kms_key_ring" "k8s_key_ring" {
  project  = var.project_id
  name     = "gke-etcd-key-ring-cluster-${var.cluster_name}"
  location = var.cluster_region
}

resource "google_kms_crypto_key" "k8s_etcd_kms_key" {
  name            = "gke-etcd-enc-key-${var.cluster_name}"
  key_ring        = google_kms_key_ring.k8s_key_ring.id
  rotation_period = "100000s"
}