resource "github_team" "tfer--Development" {
  name    = "Development"
  privacy = "closed"
}

resource "github_team_repository" "tfer--Development_iron-002E-security" {
  permission = "push"
  repository = "iron.security"
  team_id    = "${github_team.tfer--Development.id}"
}

resource "github_team_repository" "tfer--Development_platform" {
  permission = "push"
  repository = "platform"
  team_id    = "${github_team.tfer--Development.id}"
}

resource "github_team_membership" "tfer--Development_beurdow" {
  role     = "member"
  team_id  = "${github_team.tfer--Development.id}"
  username = "beurdow"
}

resource "github_team_membership" "tfer--Development_hazcod" {
  role     = "maintainer"
  team_id  = "${github_team.tfer--Development.id}"
  username = "hazcod"
}
