module "platform_dev" {
  source = "../environment"

  name        = "platform-dev"
  environment = "dev"
  labels = {
    "environment" : "dev",
    "app" : "platform",
  }
}