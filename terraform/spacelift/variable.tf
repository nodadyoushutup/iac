variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

variable "ENV" {
  type = string
  description = "Environment configuration"
  default = 0
}

variable "ANSIBLE_CONFIG" {
  type = string
  description = "Ansible configuration path"
  default = null
}

variable "PRIVATE_KEY" {
  type = string
  description = "SSH private key path"
  default = null
}