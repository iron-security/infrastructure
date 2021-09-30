output "dev_cluster_ca_certificate" {
  value = module.dev_cluster.cluster_ca_certificate
}

output "dev_cluster_client_certificate" {
  value = module.dev_cluster.cluster_client_certificate
}

output "dev_cluster_client_key" {
  sensitive = true
  value     = module.dev_cluster.cluster_client_key
}

output "dev_cluster_endpoint" {
  value = module.dev_cluster.cluster_endpoint
}

# ---