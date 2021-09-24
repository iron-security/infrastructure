resource "kubernetes_namespace" "platform_prd" {
  metadata {
    annotations = {
      environment = "prd"
    }

    labels = {
      app = "platform"
    }

    name = "platform-prd"
  }
}

resource "kubernetes_network_policy" "platform_prd_deny_all_ingress" {
  metadata {
    name      = "deny-all-ingress"
    namespace = kubernetes_namespace.platform_prd.metadata[0].name
  }

  spec {
    policy_types = ["Ingress"]

    pod_selector {}

    ingress {}
  }
}