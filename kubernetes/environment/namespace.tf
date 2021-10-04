resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = var.annotations
    labels      = var.labels

    name = var.name
  }
}