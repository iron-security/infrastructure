module "platform_dev" {
  source     = "./environment"
  depends_on = [kubernetes_cluster_role_binding.admins_group]

  name        = "platform-dev"
  environment = "dev"
  labels = {
    "environment" : "dev",
    "app" : "platform",
  }
}