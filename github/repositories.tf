resource "github_repository" "infrastructure" {
  allow_merge_commit     = "true"
  allow_rebase_merge     = "true"
  allow_squash_merge     = "true"
  archived               = "false"
  delete_branch_on_merge = "false"
  description            = "Terraform monorepo for our cloud infrastructure."
  has_downloads          = "true"
  has_issues             = "true"
  has_projects           = "false"
  has_wiki               = "false"
  is_template            = "false"
  name                   = "infrastructure"
  visibility             = "private"
  vulnerability_alerts   = "true"
}



resource "github_repository" "iron_security" {
  allow_merge_commit     = "true"
  allow_rebase_merge     = "true"
  allow_squash_merge     = "true"
  archived               = "false"
  delete_branch_on_merge = "false"
  description            = "Hugo repository for the iron.security website."
  has_downloads          = "true"
  has_issues             = "true"
  has_projects           = "false"
  has_wiki               = "false"
  is_template            = "false"
  name                   = "iron.security"
  visibility             = "private"
  vulnerability_alerts   = "true"
}

resource "github_repository" "platform" {
  allow_merge_commit     = "true"
  allow_rebase_merge     = "true"
  allow_squash_merge     = "true"
  archived               = "false"
  delete_branch_on_merge = "false"
  description            = "Monorepo for our platform microservices."
  has_downloads          = "true"
  has_issues             = "true"
  has_projects           = "true"
  has_wiki               = "true"
  is_template            = "false"
  name                   = "platform"
  visibility             = "private"
  topics                 = ["api", "backend", "docker", "helm"]
  vulnerability_alerts   = "true"
}

/*
// TODO : re-enable once the repos go public or we have Pro
resource "github_branch_protection_v3" "platform_main" {
    repository = github_repository.platform.id
    branch = "main"
    enforce_admins = true
    required_status_checks {
      strict = true
    }
}
resource "github_branch_protection_v3" "iron_security_main" {
    repository = github_repository.iron_security.id
    branch = "main"
    enforce_admins = true
    required_status_checks {
      strict = true
    }
}
resource "github_branch_protection_v3" "infrastructure_main" {
    repository = github_repository.infrastructure.id
    branch = "main"
    enforce_admins = true
    required_status_checks {
      strict = true
    }
}
*/