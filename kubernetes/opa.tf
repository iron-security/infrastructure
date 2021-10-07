module "system_gatekeeper" {
  depends_on = [kubernetes_cluster_role_binding.admins_group]

  source = "./environment"

  name        = "system-gatekeeper"
  environment = "prd"
  labels = {
    "environment" : "prd",
    "app" : "gatekeeper",
  }
}