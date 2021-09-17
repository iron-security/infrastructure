resource "github_team" "development" {
  name    = "Development"
  privacy = "closed"
}

resource "github_team_repository" "development_iron_security" {
  permission = "push"
  repository = "iron.security"
  team_id    = "${github_team.development.id}"
}

resource "github_team_repository" "development_platform" {
  permission = "push"
  repository = "platform"
  team_id    = "${github_team.development.id}"
}

resource "github_team_membership" "development_beurdow" {
  role     = "member"
  team_id  = "${github_team.development.id}"
  username = "beurdow"
}

resource "github_team_membership" "development_hazcod" {
  role     = "maintainer"
  team_id  = "${github_team.development.id}"
  username = "hazcod"
}
