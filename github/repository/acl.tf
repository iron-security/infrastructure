locals {
  att_004 = join("_", var.team_ids[*])
}

resource "github_team_repository" "repo_team" {
  count = length(var.team_ids)

  permission = "push"
  repository = github_repository.repo.name
  team_id    = split("_", local.att_004)[count.index]
}