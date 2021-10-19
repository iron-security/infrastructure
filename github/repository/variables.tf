# repository name
variable "name" {}

# repository description
variable "description" {}

# team IDs that have access to the repository
variable "team_ids" {
  type = list(string)
}

# branches to be created
variable "branches" {
  type    = list(string)
  default = ["main"]
}

# any repository topics to set
variable "topics" {
  type    = list(string)
  default = []
}

# should this be publicly accessible
variable "public" {
  type    = bool
  default = false
}

# should we enable github projects
variable "projects" {
  type    = bool
  default = false
}

# should we enable github wikis
variable "wiki" {
  type    = bool
  default = false
}

# is this a template repository
variable "template" {
  type    = bool
  default = false
}

# what is the license to autocreate
variable "license" {
  default = "gpl-3.0"
}

# should we allow auto-merge PRs for contributors with write permissions
variable "allow_auto_merge" {
  default = true
}