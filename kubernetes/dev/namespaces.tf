resource "kubernetes_namespace" "platform_dev" {
  depends_on = [kubernetes_cluster_role_binding.admin_group]

  metadata {
    annotations = {
      environment = "dev"
    }

    labels = {
      app = "platform"
    }

    name = "platform-dev"
  }
}