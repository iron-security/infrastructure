resource "helm_release" "istio_base_dev" {
  name      = "gatekeeper"
  namespace = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.12.0-alpha.5"
  devel      = true

  set {
    name  = "replicaCount"
    value = 2
  }
}

resource "helm_release" "istio_istiod_dev" {
  depends_on = [
    helm_release.istio_base_dev,
  ]
  name      = "istiod"
  namespace = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.12.0-alpha.5"
  devel      = true

  set {
    name  = "replicaCount"
    value = 2
  }
}

resource "helm_release" "istio_cni_plugin_dev" {
  depends_on = [
    helm_release.istio_istiod_dev,
  ]
  name      = "istio-cni"
  namespace = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istio-cni"
  version    = "1.12.0-alpha.5"
  devel      = true

  set {
    name  = "replicaCount"
    value = 2
  }
}

resource "helm_release" "istio_egress_dev" {
  depends_on = [
    helm_release.istio_istiod_dev,
  ]
  name      = "istio-egress"
  namespace = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istio-egress"
  version    = "1.12.0-alpha.5"
  devel      = true

  set {
    name  = "replicaCount"
    value = 2
  }
}