resource "github_branch" "branch" {
  for_each = toset(var.branches)

  branch     = each.key
  repository = github_repository.repo.name
}