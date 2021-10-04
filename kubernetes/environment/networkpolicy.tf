resource "kubernetes_network_policy" "deny_all_allow_egress" {
  metadata {
    name      = "deny-all-allow-egress"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    # in and out-ward traffic
    policy_types = ["Ingress", "Egress"]

    # apply to any Pod
    pod_selector {
      match_labels = {}
    }

    # incoming traffic
    # commenting out means deny all
    # ingress {}

    # outgoing traffic
    egress {
      # allow external DNS requests
      ports {
        port     = 53
        protocol = "UDP"
      }

      # allow external HTTPS requests
      ports {
        port     = 443
        protocol = "TCP"
      }

      # allow to any external endpoint
      # TODO: investigate Pod DNS filtering in GKE clusters
      to {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }
    }
  }
}