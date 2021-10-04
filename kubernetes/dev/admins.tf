resource "kubernetes_cluster_role_binding" "admin_group" {
  metadata {
    name = "admin-group"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "Group"
    name      = var.gke_admins_group
    api_group = "rbac.authorization.k8s.io"
  }
}