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

#
# ---
#

resource "github_team" "marketing" {
  name    = "Marketing"
  privacy = "secret"
}

resource "github_team_membership" "marketing_doomed5g" {
  role     = "member"
  team_id  = github_team.marketing.id
  username = "Doomed5G"
}