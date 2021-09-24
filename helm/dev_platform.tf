locals {
    dev_platform_name       = "platform-dev"
    dev_platform_version    = "v1.0.15"
    dev_platform_namespace  = local.dev_platform_name
    dev_platform_serviceaccount = "${local.dev_platform_name}-sa"
}

/*
module "dev_platform_identity" {

}

resource "google_sql_user" {

}
*/

resource "helm_release" "platform_dev" {
    depends_on = []

    name        = local.dev_platform_name
    namespace   = local.dev_platform_namespace

    repository = "https://raw.githubusercontent.com/iron-security/platform/helm/"
    chart   = "platform/apigw"
    version = local.dev_platform_version

    set {
        name  = "replicaCount"
        value = 2
    }

    set {
        name  = "log.level"
        value = "debug"
    }
}