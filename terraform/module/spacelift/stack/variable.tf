variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

# REQUIRED
variable "name" {
  type = string
  description = "Name"
}

variable "project_root" {
  type = string
  description = "Project root"
}

# UNIQUE
variable "description" {
  type = string
  description = "Description"
  default = null
}

variable "labels" {
  type = list(string)
  description = "Labels"
  default = []
}

# GENERAL
variable "administrative" {
  type = bool
  description = "Administrative"
  default = null
}

variable "autodeploy" {
  type = bool
  description = "Autodeploy"
  default = null
}

variable "branch" {
  type = string
  description = "Branch"
  default = null
}

variable "repository" {
  type = string
  description = "Repository"
  default = null
}

variable "space_id" {
  type = string
  description = "Space ID"
  default = null
}

# TERRAFORM
variable "terraform_version" {
  type = string
  description = "Terraform version"
  default = null
}