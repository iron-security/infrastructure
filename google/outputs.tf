output "cluster_ca_certificate" {
    value = base64decode(google_container_cluster.main_cluster.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}
output "cluster_client_token" {
    sensitive = true
    value = data.google_client_config.default.access_token
}

output "cluster_endpoint" {
    value = google_container_cluster.main_cluster.endpoint
}