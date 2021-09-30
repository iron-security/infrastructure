resource "kubernetes_network_policy" "deny_all_allow_egress" {
  metadata {
    name      = "deny-all-allow-egress"
    namespace = kubernetes_namespace.platform_dev.metadata.0.name
  }

  spec {
    policy_types = ["Ingress", "Egress"]

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

      # allow to any external endpoint since we don't know the crowdstrike IPs
      to {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }
    }
  }
}