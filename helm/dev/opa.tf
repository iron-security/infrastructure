resource "helm_release" "opa_dev" {
  name      = "gatekeeper"
  namespace = "dev"

  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper/gatekeeper"
  version    = "3.7.0-beta.1"

  set {
    name  = "replicaCount"
    value = 2
  }
}