module "repo_infrastructure" {
  source = "./repository"

  name        = "infrastructure"
  description = "Terraform monorepo for our cloud infrastructure."
  team_ids    = [github_team.development.id]
  branches    = []
  public      = true
}

module "repo_website" {
  source = "./repository"

  name        = "website"
  description = "Hugo repository for the iron.security website."
  team_ids    = [github_team.development.id, github_team.marketing.id]
  branches    = []
  public      = true
}

module "repo_platform" {
  source = "./repository"

  name        = "platform"
  description = "Monorepo for our platform microservices."
  team_ids    = [github_team.development.id]
  #branches    = ["main", "dev", "helm"]
  branches = []
  public   = false
}

module "repo_dotgithub" {
  source = "./repository"

  name        = ".github"
  description = "README for the organisation GitHub page."
  team_ids    = [github_team.development.id, github_team.marketing.id]
  #branches    = ["main"]
  branches = []
  topics   = ["readme", "github"]
  public   = true
}

module "repo_documentation" {
  source = "./repository"

  name        = "documentation"
  description = "The IRON documentation website to share information."
  team_ids    = [github_team.development.id, github_team.marketing.id]
  #branches    = ["main"]
  branches = []
  topics   = ["docs", "documentation"]
  public   = true
}

module "repo_falconinstall" {
  source = "./repository"

  name        = "falconinstall"
  description = "Helper scripts to install the Falcon sensors to your fleet manually."
  team_ids    = [github_team.development.id]
  branches    = []
  topics      = ["docs", "falcon", "script", "install"]
  public      = false
}