resource "github_team_repository" "repo_team" {
  permission = "push"
  repository = github_repository.repo.name
  team_id    = var.team_id
}