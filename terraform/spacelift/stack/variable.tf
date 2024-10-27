variable "CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

variable "ENV" {
  type = number
  description = "Environment configuration"
  default = 0
}