variable "name" {}

variable "description" {}

variable "team_ids" {
  type = list(number)
}

variable "branches" {
  type    = list(string)
  default = ["main"]
}

variable "topics" {
  type    = list(string)
  default = []
}

variable "public" {
  type    = bool
  default = false
}

variable "projects" {
  type    = bool
  default = false
}

variable "wiki" {
  type    = bool
  default = false
}

variable "template" {
  type    = bool
  default = false
}

variable "license" {
  default = "gpl-3.0"
}