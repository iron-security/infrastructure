module "system_istio" {
  depends_on = [kubernetes_cluster_role_binding.admins_group]

  source = "./environment"

  name        = "istio-system"
  environment = "prd"
  labels = {
    "environment" : "prd",
    "app" : "istio",
  }
}