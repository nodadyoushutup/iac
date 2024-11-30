variable "PATH_CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

variable "name" {
  type = string
  description = "Virtual machine name"
  default = null
}

variable "stop_on_destroy" {
  type = bool
  description = "Virtual machine ID"
  default = true
}

variable "vm_id" {
  type = number
  description = "Virtual machine ID"
  default = null
}