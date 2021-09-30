/*
resource "github_branch_protection_v3" "main" {
  repository     = github_repository.repo.id
  branch         = var.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }
}
*/