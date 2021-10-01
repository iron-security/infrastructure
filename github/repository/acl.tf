resource "github_team_repository" "repo_team" {
  for_each = toset(var.team_ids)

  permission = "push"
  repository = github_repository.repo.name
  team_id    = each.key
}