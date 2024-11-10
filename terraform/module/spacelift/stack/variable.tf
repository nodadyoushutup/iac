variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

# REQUIRED
variable "branch" {
  type = string
  description = "Branch"
}

variable "name" {
  type = string
  description = "Name"
}

variable "repository" {
  type = string
  description = "Repository"
}

# OPTIONAL
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

variable "project_root" {
  type = string
  description = "Project root"
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