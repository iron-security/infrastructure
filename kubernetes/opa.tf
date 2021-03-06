module "system_gatekeeper" {
  depends_on = [kubernetes_cluster_role_binding.admins_group]

  source = "./environment"

  name        = "gatekeeper-system"
  environment = "prd"
  labels = {
    "environment" : "prd",
    "app" : "gatekeeper",
  }
}