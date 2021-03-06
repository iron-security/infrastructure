resource "helm_release" "opa_dev" {
  name      = "gatekeeper"
  namespace = "gatekeeper-system"

  repository = "https://open-policy-agent.github.io/gatekeeper/charts/"
  chart      = "gatekeeper"
  version    = "3.7.0"

  set {
    name  = "replicaCount"
    value = 2
  }
}