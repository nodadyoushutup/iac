variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

variable "ENV" {
  type = string
  description = "Environment configuration"
  default = null
}

variable "ANSIBLE_CONFIG" {
  type = string
  description = "Ansible configuration path"
  default = null
}