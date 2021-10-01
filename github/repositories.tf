module "repo_infrastructure" {
  source = "./repository"

  name        = "infrastructure"
  description = "Terraform monorepo for our cloud infrastructure."
  team_ids    = [github_team.development.id]
  branches    = []
}

module "repo_website" {
  source = "./repository"

  name        = "website"
  description = "Hugo repository for the iron.security website."
  team_ids    = [github_team.development.id]
  branches    = []
}

module "repo_platform" {
  source = "./repository"

  name        = "platform"
  description = "Monorepo for our platform microservices."
  team_ids    = [github_team.development.id]
  #branches    = ["main", "dev", "helm"]
  branches = []
}

module "repo_dotgithub" {
  source = "./repository"

  name        = ".github"
  description = "README for the organisation GitHub page."
  team_ids    = [github_team.development.id]
  #branches    = ["main"]
  branches = []
  topics   = ["readme", "github"]
  public   = true
}
