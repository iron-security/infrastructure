resource "github_team" "development" {
  name    = "Development"
  privacy = "secret"
}

resource "github_team_membership" "development_beurdow" {
  role     = "member"
  team_id  = github_team.development.id
  username = "beurdow"
}

resource "github_team_membership" "development_hazcod" {
  role     = "maintainer"
  team_id  = github_team.development.id
  username = "hazcod"
}
