variable "GIT_BRANCH" {
  type = string
  description = "Branch"
  default = "main"
}

variable "GIT_REPOSITORY" {
  type = string
  description = "Repository"
  default = "iac"
}

variable "FLAG_MODULE" {
  type = number
  description = "Module configuration flag"
  default = 0
}