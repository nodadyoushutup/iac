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

variable "agent" {
  type = object({
    enabled = string
  })
  description = "Agent"
  default = null
}

variable "cpu" {
  type = object({
    cores = number
    type = string
  })
  description = "CPU"
  default = null
}

variable "memory" {
  type = object({
    dedicated = number
  })
  description = "Memory"
  default = null
}

variable "disk" {
  type = object({
    datastore_id = string
    file_id = string
    interface = string
    discard = string
    size = string
  })
  description = "Disk"
  default = null
}