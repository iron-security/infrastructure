resource "github_repository" "repo" {
  # do not automatically destroy repositories so we don't lose the git contents
  lifecycle {
    prevent_destroy = true
  }

  allow_auto_merge       = var.allow_auto_merge
  allow_merge_commit     = "true"
  allow_rebase_merge     = "true"
  allow_squash_merge     = "true"
  archived               = "false"
  delete_branch_on_merge = "false"
  description            = var.description
  has_downloads          = "true"
  has_issues             = "true"
  has_projects           = var.projects
  has_wiki               = var.wiki
  is_template            = var.template
  name                   = var.name
  visibility             = var.public == true ? "public" : "private"
  #vulnerability_alerts   = "true"
  auto_init              = true
  topics                 = var.topics
  license_template       = var.license
}

