# disable default project service accounts
# so we can assign dedicated, least-privileged ones
resource "google_project_default_service_accounts" "no_default_sa" {
  project = var.project_id
  action  = "DELETE"
}