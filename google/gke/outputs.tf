output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.main_cluster.master_auth[0].cluster_ca_certificate)
}

output "cluster_client_certificate" {
  value = base64decode(google_container_cluster.main_cluster.master_auth[0].client_certificate)
}

output "cluster_client_key" {
  sensitive = true
  value     = base64decode(google_container_cluster.main_cluster.master_auth[0].client_key)
}

output "cluster_endpoint" {
  value = google_container_cluster.main_cluster.endpoint
}
