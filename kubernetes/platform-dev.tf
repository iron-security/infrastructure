resource "kubernetes_namespace" "platform_dev" {
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

resource "kubernetes_network_policy" "platform_dev_deny_all_ingress" {
  metadata {
    name      = "deny-all-ingress"
    namespace = kubernetes_namespace.platform_dev.metadata[0].name
  }

  spec {
    policy_types = ["Ingress"]

    pod_selector {}

    ingress {}
  }
}