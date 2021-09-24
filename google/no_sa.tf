resource "google_project_default_service_accounts" "no_default_sa" {
  project = var.project_id
  action  = "DELETE"
}