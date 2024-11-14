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

variable "spacelift_run_id" {
  type = string
  description = "Spacelift Run ID"
  default = null
}