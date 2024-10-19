variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

variable "GIT_CONFIG" {
  type = string
  description = "Git configuration"
  default = null
}

variable "ENV" {
  type = string
  description = "Environment configuration"
  default = null
}