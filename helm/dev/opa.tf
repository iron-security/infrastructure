resource "helm_release" "opa_dev" {
  name      = "gatekeeper"
  namespace = "dev"

  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper/gatekeeper"
  version    = "3.6.0"

  set {
    name  = "replicaCount"
    value = 2
  }
}